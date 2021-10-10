import 'package:business_card_quest_application/view_models/detail_page_view_model.dart';
import 'package:business_card_quest_application/view_models/edit_page_view_model.dart';
import 'package:business_card_quest_application/view_models/qr_code_page_view_model.dart';
import 'package:business_card_quest_application/view_models/gallery_page_view_model.dart';
import 'package:business_card_quest_application/view_models/home_page_view_model.dart';
import 'package:business_card_quest_application/view_models/list_page_view_model.dart';
import 'package:business_card_quest_application/view_models/scan_page_view_model.dart';
import 'package:business_card_quest_application/views/screens/detail_page.dart';
import 'package:business_card_quest_application/views/screens/qr_code_page.dart';
import 'package:business_card_quest_application/views/screens/gallery_page.dart';
import 'package:business_card_quest_application/views/screens/list_page.dart';
import 'package:business_card_quest_application/views/screens/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:business_card_quest_application/views/screens/home_page.dart';
import 'package:business_card_quest_application/views/screens/edit_page.dart';
import 'package:provider/provider.dart';
import 'package:business_card_quest_application/global/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'キャラ名刺',
        theme: ThemeData(
            textTheme:
                GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
            primarySwatch: Colors.lightBlue,
            primaryTextTheme:
                TextTheme(headline6: const TextStyle(color: Colors.white)),
            primaryIconTheme: IconThemeData(color: Colors.white),
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: RouteNames.homePage,
        routes: {
          RouteNames.homePage: (BuildContext context) => ChangeNotifierProvider(
                create: (context) => HomePageViewModel(),
                child: HomePage(),
              ),
          RouteNames.detailPage: (BuildContext context) =>
              ChangeNotifierProvider(
                create: (context) => DetailPageViewModel(),
                child: DetailPage(),
              ),
          RouteNames.editPage: (BuildContext context) => ChangeNotifierProvider(
              create: (context) => EditPageViewModel(), child: EditPage()),
          RouteNames.qrCodePage: (BuildContext context) =>
              ChangeNotifierProvider(
                  create: (context) => QRCodePageViewModel(),
                  child: QRCodePage()),
          RouteNames.scanPage: (BuildContext context) => ChangeNotifierProvider(
              create: (context) => ScanPageViewModel(), child: ScanPage()),
          RouteNames.listPage: (BuildContext context) => ChangeNotifierProvider(
              create: (context) => ListPageViewModel(), child: ListPage()),
          RouteNames.galleryPage: (BuildContext context) =>
              ChangeNotifierProvider(
                  create: (context) => GalleryPageViewModel(),
                  child: GalleryPage()),
        });
  }
}
