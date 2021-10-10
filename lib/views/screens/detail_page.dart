import 'package:business_card_quest_application/global/constants.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/models/entities/screen_arguments.dart';
import 'package:business_card_quest_application/view_models/detail_page_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key? key}) : super(key: key);
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final TextStyle titleStyle = const TextStyle(fontSize: 12);
  final TextStyle bodyStyle = const TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    final DetailPageArgument arg =
        ModalRoute.of(context)?.settings.arguments as DetailPageArgument;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(title: const Text('カード'), actions: [
              Selector<DetailPageViewModel, BusinessCard?>(
                  selector: (context, viewModel) => viewModel.editBusinessCard,
                  shouldRebuild: (previous, current) => previous != current,
                  builder: (context, editBusinessCard, child) {
                    final BusinessCard businessCard =
                        editBusinessCard ?? arg.businessCard;
                    return Visibility(
                        visible: businessCard.isOwn,
                        child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () async {
                              final BusinessCard? resultCard =
                                  await Navigator.pushNamed(
                                      context, RouteNames.editPage,
                                      arguments: businessCard) as BusinessCard?;
                              context
                                  .read<DetailPageViewModel>()
                                  .editBusinessCard = resultCard;
                            }));
                  }),
              Visibility(
                  visible: arg.callerRouteName == RouteNames.scanPage,
                  child: IconButton(
                    icon: const Icon(Icons.done, color: Colors.white),
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(RouteNames.homePage));
                    },
                  ))
            ]),
            body: Padding(
              padding: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Card(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('キャラクター', style: titleStyle),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blueGrey,
                                      ),
                                      child: Selector<DetailPageViewModel,
                                          BusinessCard?>(
                                        selector: (context, viewModel) =>
                                            viewModel.editBusinessCard,
                                        shouldRebuild: (previous, current) =>
                                            previous != current,
                                        builder:
                                            (context, editBusinessCard, child) {
                                          final BusinessCard businessCard =
                                              editBusinessCard ??
                                                  arg.businessCard;
                                          return Image.asset(
                                              businessCard
                                                  .creature.imageFilePath,
                                              fit: BoxFit.contain);
                                        },
                                      )),
                                  const SizedBox(height: 5),
                                  Selector<DetailPageViewModel, BusinessCard?>(
                                    selector: (context, viewModel) =>
                                        viewModel.editBusinessCard,
                                    shouldRebuild: (previous, current) =>
                                        previous != current,
                                    builder:
                                        (context, editBusinessCard, child) {
                                      final BusinessCard businessCard =
                                          editBusinessCard ?? arg.businessCard;
                                      return Text(businessCard.creature.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold));
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                    ),
                    Selector<DetailPageViewModel, BusinessCard?>(
                        selector: (context, viewModel) =>
                            viewModel.editBusinessCard,
                        shouldRebuild: (previous, current) =>
                            previous != current,
                        builder: (context, editBusinessCard, child) {
                          final List<List<String>> details = context
                              .read<DetailPageViewModel>()
                              .getDetails(editBusinessCard ?? arg.businessCard);
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: details.length,
                              itemBuilder: (context, index) {
                                final List<String> item = details[index];
                                return Container(
                                  width: double.infinity,
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item[0], style: titleStyle),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SelectableText(
                                            item[1],
                                            style: bodyStyle,
                                            maxLines: null,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }),
                    Selector<DetailPageViewModel, BusinessCard?>(
                        selector: (context, viewModel) =>
                            viewModel.editBusinessCard,
                        shouldRebuild: (previous, current) =>
                            previous != current,
                        builder: (context, editBusinessCard, child) {
                          final BusinessCard businessCard =
                              editBusinessCard ?? arg.businessCard;
                          return Visibility(
                              visible: !businessCard.isOwn,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: Text(
                                          '最終更新 : ${dateFormat.format(businessCard.modifiedAt.toLocal())}'))));
                        }),
                  ],
                ),
              ),
            )));
  }
}
