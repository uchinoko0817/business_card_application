import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:business_card_quest_application/view_models/edit_page_view_model.dart';

class EditPage extends StatelessWidget {
  EditPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<int, TextInputType> _textInputTypeMap = {
    TextInputTypes.text: TextInputType.text,
    TextInputTypes.multiline: TextInputType.multiline,
    TextInputTypes.number: TextInputType.number,
    TextInputTypes.emailAddress: TextInputType.emailAddress,
    TextInputTypes.url: TextInputType.url
  };

  @override
  Widget build(BuildContext context) {
    final BusinessCard businessCard =
        ModalRoute.of(context)?.settings.arguments as BusinessCard;
    return WillPopScope(
        onWillPop: () async {
          if (context.read<EditPageViewModel>().isSaving) {
            return false;
          }
          bool result = true;
          if (context.read<EditPageViewModel>().isChanged) {
            result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: const Text('確認'),
                            content: const Text('編集内容は保存されませんが、よろしいですか？'),
                            actions: <Widget>[
                              TextButton(
                                  child: const Text('OK'),
                                  onPressed: () =>
                                      Navigator.pop(context, true)),
                              TextButton(
                                  child: const Text('キャンセル'),
                                  onPressed: () =>
                                      Navigator.pop(context, false)),
                            ])) ??
                false;
          }
          if (result) {
            Navigator.pop(context, businessCard);
          }
          return false;
        },
        child: Form(
            key: _formKey,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('カード(編集)'),
                  actions: <Widget>[
                    Selector<EditPageViewModel, bool>(
                      selector: (context, viewModel) => viewModel.isChanged,
                      shouldRebuild: (previous, current) => previous != current,
                      builder: (context, isChanged, child) {
                        return Visibility(
                            visible: isChanged,
                            child: IconButton(
                                icon: const Icon(Icons.save),
                                color: Colors.white,
                                onPressed: () async {
                                  final FocusScopeNode currentScope =
                                      FocusScope.of(context);
                                  if (!currentScope.hasPrimaryFocus &&
                                      currentScope.hasFocus) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    final BusinessCard? resultCard =
                                        await context
                                            .read<EditPageViewModel>()
                                            .writeEditData(businessCard);
                                    Navigator.pop(context, resultCard);
                                  }
                                }));
                      },
                    ),
                  ],
                ),
                body: Consumer<EditPageViewModel>(
                    builder: (context, viewModel, child) {
                  if (context.read<EditPageViewModel>().isSaving) {
                    return const Center(
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: const CircularProgressIndicator()));
                  }
                  final List<EditRowItem> rowItems = context
                      .read<EditPageViewModel>()
                      .getRowItems(businessCard);
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const SizedBox(height: 20),
                          Visibility(
                              visible: context
                                  .read<EditPageViewModel>()
                                  .isContainError,
                              child: Container(
                                  child: Text('エラーがあります',
                                      style: TextStyle(color: Colors.red[900])),
                                  color: Colors.pink[200],
                                  width: double.infinity,
                                  alignment: Alignment.center)),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rowItems.length,
                              itemBuilder: (context, index) {
                                final EditRowItem row = rowItems[index];
                                return Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 20),
                                    child: TextFormField(
                                      initialValue: row.initialValue,
                                      maxLength: row.maxLength,
                                      maxLines: row.maxLines,
                                      validator: row.validator,
                                      onChanged: (text) {
                                        context
                                            .read<EditPageViewModel>()
                                            .isChanged = true;
                                      },
                                      onSaved: (value) {
                                        row.onSave?.call(value?.trim() ?? '');
                                      },
                                      decoration: InputDecoration(
                                          labelText: row.title,
                                          helperText: row.helperText,
                                          enabledBorder:
                                              const OutlineInputBorder()),
                                      keyboardType:
                                          _textInputTypeMap[row.textInputType],
                                    ));
                              })
                        ])),
                  );
                }))));
  }
}
