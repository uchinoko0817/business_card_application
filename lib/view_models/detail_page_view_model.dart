import 'package:business_card_quest_application/global/constants.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:flutter/cupertino.dart';

class DetailPageViewModel extends ChangeNotifier {
  // private fields
  BusinessCard? _editBusinessCard;

  // properties
  BusinessCard? get editBusinessCard => _editBusinessCard;

  set editBusinessCard(BusinessCard? businessCard) {
    _editBusinessCard = businessCard;
    notifyListeners();
  }

  List<List<String>> getDetails(BusinessCard card) {
    return [
      [DisplayItemTitles.name, card.name],
      [DisplayItemTitles.companyName, card.companyName],
      [DisplayItemTitles.branchName, card.branchName],
      [DisplayItemTitles.departmentName, card.departmentName],
      [DisplayItemTitles.positionName, card.positionName],
      [DisplayItemTitles.qualification, card.qualification],
      [DisplayItemTitles.postalCode, card.postalCode],
      [DisplayItemTitles.address, card.address],
      [DisplayItemTitles.phoneNumber, card.phoneNumber],
      [DisplayItemTitles.mailAddress, card.mailAddress],
      [DisplayItemTitles.websiteUrl, card.websiteUrl],
      [DisplayItemTitles.freeMessage, card.freeMessage]
    ].where((pair) => pair[1].isNotEmpty).toList();
  }
}
