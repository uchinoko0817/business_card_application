import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/models/services/business_card_service.dart';
import 'package:flutter/cupertino.dart';

class ListPageViewModel extends ChangeNotifier {
  // private fields
  bool _isNoData = true;
  String _filter = '';
  BusinessCard? _deleteCard;
  List<BusinessCard> _initialBusinessCards = [];
  List<BusinessCard> _filteredBusinessCards = [];
  final TextEditingController _searchBoxController = TextEditingController();

  // properties
  bool get isNoData => _isNoData;

  List<BusinessCard> get businessCards => _filteredBusinessCards;

  TextEditingController get searchBoxController => _searchBoxController;

  // constructor
  ListPageViewModel() {
    _searchBoxController.addListener(() {
      _filter = _searchBoxController.text.trim();
      _filteredBusinessCards =
          _filterBusinessCards(_initialBusinessCards, _filter);
      notifyListeners();
    });
  }

  Future<void> initScreenData() async {
    final BusinessCardService service = BusinessCardService.instance;
    final BusinessCard? deleteCard = _deleteCard;
    if (deleteCard != null) {
      await service.delete(deleteCard.id);
      _deleteCard = null;
    }
    final List<BusinessCard> cards = [];
    await service.readBusinessCards(cards, isOwn: false);
    _isNoData = cards.isEmpty;
    _sortBusinessCards(cards);
    _initialBusinessCards = cards;
    _filteredBusinessCards = _filterBusinessCards(cards, _filter);
  }

  Future<bool> deleteCard(BusinessCard card) async {
    if (_initialBusinessCards.remove(card)) {
      _filteredBusinessCards.remove(card);
      if (_initialBusinessCards.isEmpty) {
        _isNoData = true;
        notifyListeners();
      }
      final BusinessCardService service = BusinessCardService.instance;
      return await service.delete(card.id);
    }
    return false;
  }

  void _sortBusinessCards(List<BusinessCard> cards) {
    cards.sort((a, b) => a.name.compareTo(b.name));
  }

  List<BusinessCard> _filterBusinessCards(
      List<BusinessCard> cards, String filter) {
    final List<BusinessCard> workCards = [];
    if (filter.isEmpty) {
      workCards.addAll(cards);
      return workCards;
    }
    workCards.addAll(cards.where((card) =>
        card.name.contains(filter) || card.companyName.contains(filter)));
    return workCards;
  }

  @mustCallSuper
  void dispose() {
    _searchBoxController.dispose();
    super.dispose();
  }
}
