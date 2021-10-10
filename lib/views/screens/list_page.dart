import 'package:business_card_quest_application/global/constants.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/view_models/list_page_view_model.dart';
import 'package:business_card_quest_application/models/entities/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('コレクション'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: TextField(
                  style: const TextStyle(fontSize: 14),
                  controller:
                      context.read<ListPageViewModel>().searchBoxController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: '検索',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              const SizedBox(height: 5),
              FutureBuilder(
                future: context.read<ListPageViewModel>().initScreenData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Expanded(
                      child: const Center(
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: const CircularProgressIndicator()),
                      ),
                    );
                  }
                  return context.read<ListPageViewModel>().isNoData
                      ? _getNoDataWidget(context)
                      : Consumer<ListPageViewModel>(
                          builder: (context, viewModel, child) => viewModel
                                  .isNoData
                              ? _getNoDataWidget(context)
                              : SingleChildScrollView(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: context
                                          .read<ListPageViewModel>()
                                          .businessCards
                                          .length,
                                      itemBuilder: (context, index) {
                                        final BusinessCard card = context
                                            .read<ListPageViewModel>()
                                            .businessCards[index];
                                        return Card(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  RouteNames.detailPage,
                                                  arguments:
                                                      DetailPageArgument(card));
                                            },
                                            child: Dismissible(
                                                key: Key(card.id.toString()),
                                                direction:
                                                    DismissDirection.endToStart,
                                                background: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  color: Colors.red,
                                                  child: Icon(Icons.delete,
                                                      color: Colors.white),
                                                ),
                                                confirmDismiss:
                                                    (DismissDirection
                                                        direction) async {
                                                  return await showDialog<bool>(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text('確認'),
                                                              content: Text(
                                                                  '${card.name}さんの名刺を削除してよろしいですか？'),
                                                              actions: [
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        true);
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: const Text(
                                                                      'キャンセル'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        false);
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          }) ??
                                                      false;
                                                },
                                                onDismissed: (DismissDirection
                                                    direction) async {
                                                  final FocusScopeNode
                                                      currentScope =
                                                      FocusScope.of(context);
                                                  if (!currentScope
                                                          .hasPrimaryFocus &&
                                                      currentScope.hasFocus) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  }
                                                  await context
                                                      .read<ListPageViewModel>()
                                                      .deleteCard(card);
                                                },
                                                child: ListTile(
                                                  leading: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.blueGrey,
                                                      ),
                                                      child: Image.asset(card
                                                          .creature
                                                          .imageFilePath)),
                                                  title: Text(card.name),
                                                  subtitle:
                                                      Text(card.companyName),
                                                )),
                                          ),
                                        );
                                      }),
                                ));
                },
              ),
            ],
          ),
        ));
  }

  Widget _getNoDataWidget(BuildContext context) {
    return Expanded(
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.shortestSide / 4,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                  '${AssetsPaths.common}${AssetsNames.emptyFolder}',
                  color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text('カードがありません')
        ],
      )),
    );
  }
}
