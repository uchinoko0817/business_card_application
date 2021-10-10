import 'package:business_card_quest_application/models/entities/business_card.dart';

class DetailPageArgument {
  final BusinessCard businessCard;
  final String callerRouteName;

  DetailPageArgument(this.businessCard, {this.callerRouteName = ''});
}
