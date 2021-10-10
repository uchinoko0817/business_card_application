import 'package:business_card_quest_application/utils/business_card_util.dart';
import 'package:flutter/material.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:encrypt/encrypt.dart' as en;

class QRCodePageViewModel extends ChangeNotifier {
  String getBusinessCardCSV(BusinessCard card) {
    final String rawCsv = BusinessCardUtil.getBusinessCardCsv(card);
    return _encryptAes(rawCsv);
  }

  String _encryptAes(String rawCsv) {
    final en.Key encryptionKey = en.Key.fromLength(32);
    final en.IV iv = en.IV.fromLength(16);
    return en.Encrypter(en.AES(encryptionKey)).encrypt(rawCsv, iv: iv).base64;
  }
}
