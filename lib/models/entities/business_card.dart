import 'package:business_card_quest_application/global/global_data.dart';
import 'package:business_card_quest_application/models/entities/creature.dart';
import 'package:business_card_quest_application/utils/common_util.dart';

class BusinessCard {
  int id;
  String uuid;
  String name;
  String companyName;
  String branchName;
  String departmentName;
  String positionName;
  String qualification;
  String postalCode;
  String address;
  String phoneNumber;
  String mailAddress;
  String websiteUrl;
  String freeMessage;
  int creatureCode;
  bool isOwn;
  bool isFavorite;
  bool isDeleted;
  DateTime createdAt;
  DateTime modifiedAt;

  Creature get creature => GlobalData.creatureMap[creatureCode]!;

  BusinessCard(
      {this.id = 0,
      this.uuid = '',
      this.name = '',
      this.companyName = '',
      this.branchName = '',
      this.departmentName = '',
      this.positionName = '',
      this.qualification = '',
      this.postalCode = '',
      this.address = '',
      this.phoneNumber = '',
      this.mailAddress = '',
      this.websiteUrl = '',
      this.freeMessage = '',
      this.creatureCode = 0,
      this.isOwn = false,
      this.isFavorite = false,
      this.isDeleted = false,
      DateTime? createdAt,
      DateTime? modifiedAt})
      : this.createdAt = createdAt ?? CommonUtil.getUtcNow(),
        this.modifiedAt = modifiedAt ?? CommonUtil.getUtcNow();

  BusinessCard clone() {
    return BusinessCard(
        id: id,
        uuid: uuid,
        name: name,
        companyName: companyName,
        branchName: branchName,
        departmentName: departmentName,
        positionName: positionName,
        qualification: qualification,
        postalCode: postalCode,
        address: address,
        phoneNumber: phoneNumber,
        mailAddress: mailAddress,
        websiteUrl: websiteUrl,
        freeMessage: freeMessage,
        creatureCode: creatureCode,
        isOwn: isOwn,
        isFavorite: isFavorite,
        isDeleted: isDeleted,
        createdAt: createdAt,
        modifiedAt: modifiedAt);
  }
}
