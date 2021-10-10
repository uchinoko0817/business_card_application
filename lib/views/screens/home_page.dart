import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:business_card_quest_application/view_models/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:business_card_quest_application/models/entities/screen_arguments.dart';
import 'package:business_card_quest_application/global/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('ホーム'),
            iconTheme: IconThemeData(color: Colors.white)),
        body: Consumer<HomePageViewModel>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
                future: viewModel.initScreenData().then((result) async {
                  if (result == InitResult.fail) {
                    await _showFailureAlertDialog(context);
                  } else if (result == InitResult.created) {
                    await _showRegistrationDialog(context);
                  }
                  return result;
                }),
                builder:
                    (BuildContext context, AsyncSnapshot<InitResult> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                        child: const SizedBox(
                            height: 100,
                            width: 100,
                            child: const CircularProgressIndicator()));
                  }
                  final BusinessCard? card = viewModel.card;
                  final List<List<dynamic>> homeButtons = [
                    [
                      'マイカード',
                      '${AssetsPaths.common}${AssetsNames.idCard}',
                      card == null
                          ? null
                          : () async {
                              await Navigator.pushNamed(
                                  context, RouteNames.detailPage,
                                  arguments: DetailPageArgument(card));
                              viewModel.reloadScreenData();
                            },
                    ],
                    [
                      'わたす',
                      '${AssetsPaths.common}${AssetsNames.qr}',
                      card == null
                          ? null
                          : () async {
                              Navigator.pushNamed(
                                  context, RouteNames.qrCodePage,
                                  arguments: card);
                            },
                    ],
                    [
                      'うけとる',
                      '${AssetsPaths.common}${AssetsNames.qrCodeScan}',
                      () async {
                        if (await Permission.camera.request().isGranted) {
                          Navigator.pushNamed(context, RouteNames.scanPage);
                        }
                      }
                    ],
                    [
                      'コレクション',
                      '${AssetsPaths.common}${AssetsNames.userList}',
                      () {
                        Navigator.pushNamed(context, RouteNames.listPage);
                      }
                    ],
                    [
                      'ギャラリー',
                      '${AssetsPaths.common}${AssetsNames.windowOfFourRoundedSquares}',
                      () {
                        Navigator.pushNamed(context, RouteNames.galleryPage,
                            arguments: card);
                      }
                    ],
                    [
                      'アプリ情報',
                      '${AssetsPaths.common}${AssetsNames.information}',
                      () {
                        showAboutDialog(
                            context: context,
                            applicationName: 'キャラ名刺',
                            applicationVersion:
                                '${Versions.appMajorVersion}.${Versions.appMinorVersion}.${Versions.appPatchVersion}β',
                            applicationIcon: SizedBox(
                              width: 80,
                              child: Image.asset(
                                  '${AssetsPaths.common}${AssetsNames.icLauncherRound}'),
                            ),
                            children: [
                              const Text(
                                  'Icons made by Freepik from www.flaticon.com')
                            ]);
                      }
                    ]
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.extent(
                      maxCrossAxisExtent:
                          MediaQuery.of(context).size.shortestSide / 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                      children: List.generate(homeButtons.length, (index) {
                        final String buttonName = homeButtons[index][0];
                        final String assetName = homeButtons[index][1];
                        final VoidCallback callback = homeButtons[index][2];
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: FractionallySizedBox(
                                heightFactor: 0.8,
                                widthFactor: 0.8,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder()),
                                    child: FractionallySizedBox(
                                      heightFactor: 0.5,
                                      widthFactor: 0.5,
                                      child: Image.asset(
                                        assetName,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: callback,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(buttonName)
                          ],
                        );
                      }),
                    ),
                  );
                });
          },
        ));
  }

  Future<void> _showRegistrationDialog(BuildContext context) async {
    final BusinessCard? card = context.read<HomePageViewModel>().card;
    if (card == null) {
      return;
    }
    final PageController? pageController =
        context.read<HomePageViewModel>().pageController;
    if (pageController == null) {
      return;
    }
    final String? Function(String?) nameValidator =
        context.read<HomePageViewModel>().nameValidator;
    final String? Function(String?) companyNameValidator =
        context.read<HomePageViewModel>().companyNameValidator;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String name = '';
    String companyName = '';
    await showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text('基本情報入力'),
              scrollable: false,
              content: Container(
                height: MediaQuery.of(context).size.height >= 280
                    ? 280
                    : MediaQuery.of(context).size.height * 3 / 4,
                width: MediaQuery.of(context).size.width * 3 / 4,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                                maxLength: DisplayItemMaxLengths.name,
                                initialValue: name,
                                validator: nameValidator,
                                onSaved: (value) {
                                  name = value?.trim() ?? '';
                                },
                                decoration: InputDecoration(
                                    helperText: Messages.required,
                                    labelText: DisplayItemTitles.name,
                                    enabledBorder: const OutlineInputBorder())),
                            const SizedBox(height: 10),
                            TextFormField(
                                maxLength: DisplayItemMaxLengths.companyName,
                                initialValue: companyName,
                                validator: companyNameValidator,
                                onSaved: (value) {
                                  companyName = value?.trim() ?? '';
                                },
                                decoration: InputDecoration(
                                    labelText: DisplayItemTitles.companyName,
                                    enabledBorder: const OutlineInputBorder())),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              child: const Text('次へ'),
                              onPressed: () {
                                final FocusScopeNode currentScope =
                                    FocusScope.of(context);
                                if (!currentScope.hasPrimaryFocus &&
                                    currentScope.hasFocus) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  pageController.nextPage(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.black),
                                  onPressed: () {
                                    pageController.previousPage(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeIn);
                                  }),
                              Flexible(
                                child: Text('あなたは${card.creature.name}です！'),
                              )
                            ],
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.6,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(30),
                                child: Image.asset(card.creature.imageFilePath),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(colors: [
                                      Colors.yellow,
                                      Colors.transparent
                                    ])),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            child: const Text('はじめる'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
    context.read<HomePageViewModel>().registerDetail(name, companyName);
  }

  Future<void> _showFailureAlertDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('エラー'),
            content: const Text('データの読込に失敗しました'),
            actions: [
              ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
