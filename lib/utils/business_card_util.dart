import 'package:business_card_quest_application/global/constants.dart';
import 'package:business_card_quest_application/global/global_data.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/models/entities/creature.dart';
import 'package:business_card_quest_application/utils/common_util.dart';

class BusinessCardUtil {
  static Map<String, dynamic> getMapFromBusinessCard(
      BusinessCard businessCard) {
    return {
      DataBaseColumnTitles.uuid: businessCard.uuid,
      DataBaseColumnTitles.name: businessCard.name,
      DataBaseColumnTitles.companyName: businessCard.companyName,
      DataBaseColumnTitles.branchName: businessCard.branchName,
      DataBaseColumnTitles.departmentName: businessCard.departmentName,
      DataBaseColumnTitles.positionName: businessCard.positionName,
      DataBaseColumnTitles.qualification: businessCard.qualification,
      DataBaseColumnTitles.postalCode: businessCard.postalCode,
      DataBaseColumnTitles.address: businessCard.address,
      DataBaseColumnTitles.phoneNumber: businessCard.phoneNumber,
      DataBaseColumnTitles.mailAddress: businessCard.mailAddress,
      DataBaseColumnTitles.websiteUrl: businessCard.websiteUrl,
      DataBaseColumnTitles.freeMessage: businessCard.freeMessage,
      DataBaseColumnTitles.creatureCode: businessCard.creatureCode,
      DataBaseColumnTitles.isOwn: CommonUtil.boolToInt(businessCard.isOwn),
      DataBaseColumnTitles.isFavorite:
          CommonUtil.boolToInt(businessCard.isFavorite),
      DataBaseColumnTitles.isDeleted:
          CommonUtil.boolToInt(businessCard.isDeleted),
      DataBaseColumnTitles.createdAt:
          CommonUtil.dateTimeToString(businessCard.createdAt),
      DataBaseColumnTitles.modifiedAt:
          CommonUtil.dateTimeToString(businessCard.modifiedAt)
    };
  }

  static BusinessCard getBusinessCardFromMap(Map<String, dynamic> map) {
    return BusinessCard(
        id: map[DataBaseColumnTitles.id],
        uuid: map[DataBaseColumnTitles.uuid],
        name: map[DataBaseColumnTitles.name],
        companyName: map[DataBaseColumnTitles.companyName],
        branchName: map[DataBaseColumnTitles.branchName],
        departmentName: map[DataBaseColumnTitles.departmentName],
        positionName: map[DataBaseColumnTitles.positionName],
        qualification: map[DataBaseColumnTitles.qualification],
        postalCode: map[DataBaseColumnTitles.postalCode],
        address: map[DataBaseColumnTitles.address],
        phoneNumber: map[DataBaseColumnTitles.phoneNumber],
        mailAddress: map[DataBaseColumnTitles.mailAddress],
        websiteUrl: map[DataBaseColumnTitles.websiteUrl],
        freeMessage: map[DataBaseColumnTitles.freeMessage],
        creatureCode: map[DataBaseColumnTitles.creatureCode],
        isOwn: CommonUtil.intToBool(map[DataBaseColumnTitles.isOwn]),
        isFavorite: CommonUtil.intToBool(map[DataBaseColumnTitles.isFavorite]),
        isDeleted: CommonUtil.intToBool(map[DataBaseColumnTitles.isDeleted]),
        createdAt: DateTime.parse('${map[DataBaseColumnTitles.createdAt]}Z'),
        modifiedAt: DateTime.parse('${map[DataBaseColumnTitles.modifiedAt]}Z'));
  }

  static String? validateIllegalChars(String value) {
    if (CommonUtil.stringIllegalCharCheck(
            GlobalData.commonIllegalChars, value) ==
        false) {
      return '${GlobalData.commonIllegalChars.join(' ')} は使用できません';
    }
    return null;
  }

  static Creature getRandomCreature() {
    final List<Creature> creatureList = GlobalData.creatureMap.values.toList();
    return creatureList[CommonUtil.getWeightRandomIndex(
        List.generate(creatureList.length, (i) => 6 - creatureList[i].rarity))];
  }

  static String getBusinessCardCsv(BusinessCard card) {
    final List<String> items = [
      Versions.appMajorVersion.toString(),
      Versions.appMinorVersion.toString(),
      Versions.appPatchVersion.toString(),
      card.uuid,
      card.name,
      card.companyName,
      card.branchName,
      card.departmentName,
      card.positionName,
      card.qualification,
      card.postalCode,
      card.address,
      card.phoneNumber,
      card.mailAddress,
      card.websiteUrl,
      card.freeMessage,
      card.creatureCode.toString(),
      CommonUtil.dateTimeToString(card.createdAt),
      CommonUtil.dateTimeToString(card.modifiedAt)
    ];
    return CommonUtil.encodeCsv(items);
  }

  static BusinessCard? getBusinessCardFromCsv(String data) {
    final List<String> items = CommonUtil.decodeCsv(data);
    if (items.length != 19) {
      return null;
    }
    final BusinessCard card = BusinessCard();
    final DateTime nowUtc = DateTime.now().toUtc();
    try {
      card.uuid = items[3];
      card.name = items[4];
      card.companyName = items[5];
      card.branchName = items[6];
      card.departmentName = items[7];
      card.positionName = items[8];
      card.qualification = items[9];
      card.postalCode = items[10];
      card.address = items[11];
      card.phoneNumber = items[12];
      card.mailAddress = items[13];
      card.websiteUrl = items[14];
      card.freeMessage = items[15];
      card.creatureCode = int.parse(items[16]);
      card.createdAt = nowUtc;
      card.modifiedAt = nowUtc;
      return card;
    } catch (e) {
      return null;
    }
  }
}
