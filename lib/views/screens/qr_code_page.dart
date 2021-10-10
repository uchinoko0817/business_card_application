import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:business_card_quest_application/view_models/qr_code_page_view_model.dart';

class QRCodePage extends StatelessWidget {
  QRCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BusinessCard businessCard =
        ModalRoute.of(context)?.settings.arguments as BusinessCard;
    return Scaffold(
      appBar: AppBar(title: const Text('わたす')),
      body: Center(
          child: AspectRatio(
        aspectRatio: 1,
        child: FractionallySizedBox(
          heightFactor: 0.8,
          widthFactor: 0.8,
          child: QrImage(
            data: context
                .read<QRCodePageViewModel>()
                .getBusinessCardCSV(businessCard),
            version: QrVersions.auto,
          ),
        ),
      )),
    );
  }
}
