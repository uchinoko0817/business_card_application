import 'package:business_card_quest_application/global/constants.dart';
import 'package:business_card_quest_application/models/entities/creature.dart';
import 'package:business_card_quest_application/models/services/business_card_service.dart';
import 'package:business_card_quest_application/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:business_card_quest_application/models/entities/config.dart';
import 'package:business_card_quest_application/models/services/config_service.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/utils/business_card_util.dart';

enum InitResult { success, fail, created }

class HomePageViewModel extends ChangeNotifier {
  // private fields
  BusinessCard? _updateCard;
  BusinessCard? _card;
  Config? _config;
  PageController? _pageController;

  // properties
  BusinessCard? get card => _card;

  PageController? get pageController => _pageController;

  String? Function(String?) get nameValidator => (value) {
        if (value == null || value.isEmpty) {
          return Messages.enterRequiredItem;
        }
        return BusinessCardUtil.validateIllegalChars(value);
      };

  String? Function(String?) get companyNameValidator => (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        return BusinessCardUtil.validateIllegalChars(value);
      };

  Future<InitResult> initScreenData() async {
    if (await _readConfig() == false) {
      if (await _writeConfig() == false) {
        return InitResult.fail;
      }
    }

    final BusinessCard? updateCard = _updateCard;
    if (updateCard != null) {
      await _writeUpdateCard(updateCard);
      _updateCard = null;
    }

    if (await _readCard() == false) {
      return InitResult.fail;
    }
    if (_card == null) {
      if (await _writeNewCard() == false) {
        return InitResult.fail;
      }
    }

    final BusinessCard? card = _card;
    if (card == null) {
      return InitResult.fail;
    }

    if (_checkBlankCard(card)) {
      _pageController = PageController();
      return InitResult.created;
    }

    return InitResult.success;
  }

  void reloadScreenData() {
    notifyListeners();
  }

  void registerDetail(String name, String companyName) {
    final BusinessCard? card = _card;
    if (card == null) {
      return;
    }
    final BusinessCard cloneCard = card.clone();
    cloneCard.name = name;
    cloneCard.companyName = companyName;
    cloneCard.modifiedAt = CommonUtil.getUtcNow();
    _updateCard = cloneCard;
    notifyListeners();
  }

  Future<bool> _writeUpdateCard(BusinessCard card) async {
    final BusinessCardService service = BusinessCardService.instance;
    return await service.update(card) > 0;
  }

  Future<bool> _readConfig() async {
    final ConfigService service = ConfigService.instance;
    final Config? tmpConfig = await service.readConfig();
    _config = tmpConfig;
    return tmpConfig != null;
  }

  Future<bool> _writeConfig() async {
    final ConfigService service = ConfigService.instance;
    final Config config = Config();
    config.createUuid();
    final bool result = await service.writeConfig(config);
    if (result) {
      _config = config;
    }
    return result;
  }

  Future<bool> _readCard() async {
    Config? config = _config;
    if (config == null) {
      return false;
    }
    final BusinessCardService service = BusinessCardService.instance;
    List<BusinessCard> tmpCards = <BusinessCard>[];
    bool result = await service.readBusinessCards(tmpCards, isOwn: true);
    if (result == false) {
      return false;
    }
    tmpCards = tmpCards.where((card) => card.uuid == config.ownUuid).toList();
    if (tmpCards.isNotEmpty) {
      _card = tmpCards.first;
    }
    return true;
  }

  Future<bool> _writeNewCard() async {
    final Config? config = _config;
    if (config == null) {
      return false;
    }
    final String uuid = config.ownUuid;
    final Creature creature = BusinessCardUtil.getRandomCreature();
    final DateTime utcNow = CommonUtil.getUtcNow();
    final BusinessCard blankCard = BusinessCard(
        uuid: uuid,
        creatureCode: creature.code,
        isOwn: true,
        createdAt: utcNow,
        modifiedAt: utcNow);

    final BusinessCardService service = BusinessCardService.instance;
    final int id = await service.insert(blankCard);
    if (0 >= id) {
      return false;
    }

    await service.activateCreature(blankCard.creatureCode);

    blankCard.id = id;
    _card = blankCard;
    return true;
  }

  bool _checkBlankCard(BusinessCard card) {
    return card.name.isEmpty;
  }

  @mustCallSuper
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
