import 'package:flutter/cupertino.dart';
import 'package:item_variance/models/item_type.dart';

import '../services/db_services.dart';

DBService dbService = DBService();

class ItemTypeProvider extends ChangeNotifier {
  //============================================================================Item Type List
  List<ItemType> _itemTypeList = [];
  //============================================================================Item Type Model Value Holder
  final ItemType _itemTypeHolder = ItemType();
  bool _addResult = false;
  bool _updateResult = false;
  bool _isEditMode = false;

  List<ItemType> get itemTypeList => _itemTypeList;
  ItemType get itemTypeHolder => _itemTypeHolder;
  bool get addResult => _addResult;
  bool get updateResult => _updateResult;
  bool get isEditMode => _isEditMode;

  //============================================================================Get List of Item Type Provider
  getAllItemTypeProvider() {
    try {
      //========================================================================Get Item Type Service
      dbService.getAllItemTypeDbService().then((value) {
        _itemTypeList = value;
      });

      notifyListeners();
    } catch (e) {
      return [];
    }
  }

  //============================================================================Get Value From Form
  getItemTypeValueProvider(String itemTypevalue) {
    try {
      _itemTypeHolder.typeName = itemTypevalue;

      notifyListeners();
    } catch (e) {
      return "";
    }
  }

  //============================================================================Add Item Type Provider
  addItemTypeProvider() {
    try {
      //========================================================================Add Item Type Service
      dbService.addItemTypeDbService(_itemTypeHolder).then((value) {
        _addResult = value;
      });

      //========================================================================Get All Item Type to Refresh
      getAllItemTypeProvider();
    } catch (e) {
      return;
    }
  }

  //============================================================================Edit Item Type
  editItemTypeProvider(ItemType itemType) {
    //==========================================================================Assign Value to Model
    _itemTypeHolder.typeName = itemType.typeName;
    //==========================================================================Edit Mode
    _isEditMode = true;

    notifyListeners();
  }

  //============================================================================Save Edit Item Type
  updateItemTypeProvider() {
    try {
      //========================================================================Update Item Type Service
      dbService.updateItemTypeDbService(_itemTypeHolder).then((value) {
        _updateResult = value;
      });
      //========================================================================Edit Mode
      _isEditMode = false;
      //========================================================================Get All Item Type to Refresh
      getAllItemTypeProvider();
    } catch (e) {
      return;
    }
  }

  //============================================================================Item Type Cancel
  cancelItemType() {
    _itemTypeHolder.typeName = null;

    notifyListeners();
  }
}
