import 'package:uuid/uuid.dart';
import 'package:business_card_quest_application/global/constants.dart';

class Config{

  String ownUuid = '';

  void createUuid(){
    Uuid uuid = Uuid();
    ownUuid = uuid.v4();
  }

  Map<String, String> toMap(){
    return {
      XmlElementTitles.uuid: ownUuid
    };
  }

}