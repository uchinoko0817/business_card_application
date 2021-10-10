import 'package:business_card_quest_application/global/global_data.dart';
import 'package:business_card_quest_application/models/entities/creature.dart';
import 'package:business_card_quest_application/models/services/business_card_service.dart';
import 'package:flutter/material.dart';

class GalleryPageViewModel extends ChangeNotifier {
  // private fields
  List<Creature> _creatures = GlobalData.creatureMap.values.toList();
  List<bool> _collectionFlags = [];

  // properties
  List<Creature> get creatures => _creatures;

  List<bool> get collectionFlags => _collectionFlags;

  int get countCollected => _collectionFlags.where((b) => b == true).length;

  int get countAll => _collectionFlags.length;

  Future<void> initScreenData() async {
    final BusinessCardService service = BusinessCardService.instance;
    final List<int> collectedCodes = [];
    await service.readAllCreatureCodes(collectedCodes);
    _collectionFlags = List.generate(_creatures.length, (index) => false);
    int j = 0;
    for (int i = 0; i < _creatures.length; i++) {
      if (j >= collectedCodes.length) {
        break;
      }
      if (_creatures[i].code == collectedCodes[j]) {
        _collectionFlags[i] = true;
        j++;
      }
    }
  }
}
