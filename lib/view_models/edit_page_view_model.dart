import 'package:business_card_quest_application/models/services/business_card_service.dart';
import 'package:business_card_quest_application/utils/business_card_util.dart';
import 'package:business_card_quest_application/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/global/constants.dart';

class EditPageViewModel extends ChangeNotifier {
  // private fields
  bool _isContainError = false;
  bool _isSaving = false;
  bool _isChanged = false;
  BusinessCard _editedBusinessCard = BusinessCard();

  // properties
  bool get isContainError => _isContainError;

  bool get isChanged => _isChanged;

  bool get isSaving => _isSaving;

  set isChanged(bool value) {
    _isChanged = value;
    notifyListeners();
  }

  Future<BusinessCard?> writeEditData(BusinessCard baseCard) async {
    _isSaving = true;
    notifyListeners();

    _setCardValue(baseCard);
    final BusinessCardService service = BusinessCardService.instance;
    final bool result = await service.update(_editedBusinessCard) > 0;

    _isSaving = false;
    notifyListeners();

    if (result) {
      return _editedBusinessCard;
    }

    return null;
  }

  List<EditRowItem> getRowItems(BusinessCard baseCard) {
    final String? Function(String? value) commonValidator = (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      return BusinessCardUtil.validateIllegalChars(value);
    };

    return ([
      EditRowItem(
          maxLength: DisplayItemMaxLengths.name,
          helperText: Messages.required,
          title: DisplayItemTitles.name,
          initialValue: baseCard.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return Messages.enterRequiredItem;
            }
            return BusinessCardUtil.validateIllegalChars(value);
          },
          onSave: (value) {
            _editedBusinessCard.name = value;
          }),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.companyName,
          title: DisplayItemTitles.companyName,
          initialValue: baseCard.companyName,
          validator: commonValidator,
          onSave: (value) {
            _editedBusinessCard.companyName = value;
          }),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.branchName,
          title: DisplayItemTitles.branchName,
          initialValue: baseCard.branchName,
          validator: commonValidator,
          onSave: (value) {
            _editedBusinessCard.branchName = value;
          }),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.departmentName,
          title: DisplayItemTitles.departmentName,
          initialValue: baseCard.departmentName,
          validator: commonValidator,
          onSave: (value) {
            _editedBusinessCard.departmentName = value;
          }),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.positionName,
          title: DisplayItemTitles.positionName,
          initialValue: baseCard.positionName,
          validator: commonValidator,
          onSave: (value) {
            _editedBusinessCard.positionName = value;
          }),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.qualification,
          title: DisplayItemTitles.qualification,
          initialValue: baseCard.qualification,
          validator: commonValidator,
          onSave: (value) {
            _editedBusinessCard.qualification = value;
          }),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.postalCode,
          title: DisplayItemTitles.postalCode,
          initialValue: baseCard.postalCode,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            if (RegExp(r'^[-\d]+$').hasMatch(value) == false) {
              return '半角数字またはハイフンを使用してください';
            }
            return null;
          },
          onSave: (value) {
            _editedBusinessCard.postalCode = value;
          },
          textInputType: TextInputTypes.number),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.address,
          title: DisplayItemTitles.address,
          initialValue: baseCard.address,
          validator: commonValidator,
          onSave: (value) {
            _editedBusinessCard.address = value;
          }),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.phoneNumber,
          title: DisplayItemTitles.phoneNumber,
          initialValue: baseCard.phoneNumber,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            if (RegExp(r'^[-\d]+$').hasMatch(value) == false) {
              return '半角数字またはハイフンを使用してください';
            }
            return null;
          },
          onSave: (value) {
            _editedBusinessCard.phoneNumber = value;
          },
          textInputType: TextInputTypes.number),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.mailAddress,
          title: DisplayItemTitles.mailAddress,
          initialValue: baseCard.mailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            if (RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$')
                    .hasMatch(value) ==
                false) {
              return '形式が不正です';
            }
            return null;
          },
          onSave: (value) {
            _editedBusinessCard.mailAddress = value;
          },
          textInputType: TextInputTypes.emailAddress),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.websiteUrl,
          title: DisplayItemTitles.websiteUrl,
          initialValue: baseCard.websiteUrl,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            if (RegExp(r'^https?://.+$').hasMatch(value) == false) {
              return '形式が不正です';
            }
            return null;
          },
          onSave: (value) {
            _editedBusinessCard.websiteUrl = value;
          },
          textInputType: TextInputTypes.url),
      EditRowItem(
          maxLength: DisplayItemMaxLengths.freeMessage,
          maxLines: 4,
          title: DisplayItemTitles.freeMessage,
          initialValue: baseCard.freeMessage,
          validator: (value) => null,
          onSave: (value) {
            _editedBusinessCard.freeMessage = value;
          },
          textInputType: TextInputTypes.multiline)
    ]);
  }

  void _setCardValue(BusinessCard baseCard) {
    final DateTime nowUtc = CommonUtil.getUtcNow();
    _editedBusinessCard.id = baseCard.id;
    _editedBusinessCard.uuid = baseCard.uuid;
    _editedBusinessCard.creatureCode = baseCard.creatureCode;
    _editedBusinessCard.isOwn = baseCard.isOwn;
    _editedBusinessCard.isFavorite = baseCard.isFavorite;
    _editedBusinessCard.isDeleted = baseCard.isDeleted;
    _editedBusinessCard.createdAt = baseCard.createdAt;
    _editedBusinessCard.modifiedAt = baseCard.modifiedAt;
    _editedBusinessCard.modifiedAt = nowUtc;
  }
}

class TextInputTypes {
  static const int text = 0;
  static const int multiline = 1;
  static const int number = 2;
  static const int emailAddress = 3;
  static const int url = 4;
}

class EditRowItem {
  int maxLength;
  int maxLines;
  String? helperText;
  String title;
  String initialValue;
  String? Function(String?)? validator;
  Function(String)? onSave;
  int textInputType;

  EditRowItem(
      {this.maxLength = 0,
      this.maxLines = 1,
      this.helperText,
      this.title = '',
      this.initialValue = '',
      this.validator,
      this.onSave,
      this.textInputType = TextInputTypes.text});
}
