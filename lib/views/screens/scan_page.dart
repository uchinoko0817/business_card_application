import 'package:business_card_quest_application/global/constants.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/view_models/scan_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:business_card_quest_application/models/entities/screen_arguments.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatelessWidget {
  ScanPage({Key? key}) : super(key: key);
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('うけとる')),
        body: Center(child: _buildScannerWidget(context)));
  }

  Widget _buildScannerWidget(BuildContext context) {
    final ScanPageViewModel viewModel = context.read<ScanPageViewModel>();
    return QRView(
      key: _qrKey,
      onQRViewCreated: (qrViewController) async {
        viewModel.qrViewController = qrViewController;
        qrViewController.scannedDataStream.listen((barcode) async {
          if (viewModel.isPausingCamera) {
            return;
          }
          viewModel.isPausingCamera = true;
          await qrViewController.pauseCamera();
          viewModel.isPausingCamera = false;

          BusinessCard? businessCard =
              await viewModel.saveBusinessCard(barcode.code);

          if (businessCard == null) {
            await showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                        title: const Text('エラー'),
                        content: const Text('データの読込に失敗しました'),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.pop(context)),
                        ]));
            try {
              await qrViewController.resumeCamera();
            } catch (e) {
              // TODO: ログ
            }
          } else {
            try {
              await qrViewController.stopCamera();
            } catch (e) {
              // TODO: ログ
            }
            await Navigator.pushNamed(context, RouteNames.detailPage,
                arguments: DetailPageArgument(businessCard,
                    callerRouteName: RouteNames.scanPage));
            try {
              await qrViewController.resumeCamera();
            } catch (e) {
              // TODO: ログ
            }
          }
        });
      },
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 16,
        borderLength: 24,
        borderWidth: 8,
      ),
    );
  }
}
