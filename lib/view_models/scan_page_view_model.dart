import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/models/services/business_card_service.dart';
import 'package:business_card_quest_application/utils/business_card_util.dart';
import 'package:business_card_quest_application/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:encrypt/encrypt.dart' as en;

class ScanPageViewModel extends ChangeNotifier {
  // private fields
  QRViewController? _qrViewController;

  // properties
  bool isPausingCamera = false;

  set qrViewController(QRViewController? qrViewController) =>
      _qrViewController = qrViewController;

  Future<BusinessCard?> saveBusinessCard(String data) async {
    BusinessCard? card =
        BusinessCardUtil.getBusinessCardFromCsv(_decryptAes(data));
    if (card == null) {
      return null;
    }
    final BusinessCardService service = BusinessCardService.instance;
    final List<BusinessCard> currentCards = [];
    if (await service.readBusinessCards(currentCards,
            uuid: card.uuid, isOwn: false) ==
        false) {
      return null;
    }
    final DateTime nowUtc = CommonUtil.getUtcNow();
    if (currentCards.isEmpty) {
      card.createdAt = nowUtc;
      card.modifiedAt = nowUtc;
      final int id = await service.insert(card);
      if (id <= 0) {
        return null;
      }
      card.id = id;
    } else {
      card.id = currentCards.first.id;
      card.createdAt = currentCards.first.createdAt;
      card.modifiedAt = nowUtc;
      if (await service.update(card) == 0) {
        return null;
      }
    }
    await service.activateCreature(card.creatureCode);
    return card;
  }

  Future<int> activateCreature(int creatureCode) async {
    final BusinessCardService service = BusinessCardService.instance;
    return await service.activateCreature(creatureCode);
  }

  String _decryptAes(String data) {
    final en.Key encryptionKey = en.Key.fromLength(32);
    final en.IV iv = en.IV.fromLength(16);
    final en.Encrypter encrypter = en.Encrypter(en.AES(encryptionKey));
    final en.Encrypted encrypted = en.Encrypted.fromBase64(data);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  @mustCallSuper
  void dispose() {
    try {
      _qrViewController?.dispose();
    } catch (e) {
      //TODO:ログ
    }
    super.dispose();
  }
}
