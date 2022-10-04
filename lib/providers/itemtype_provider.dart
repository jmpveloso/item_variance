import 'package:flutter/cupertino.dart';
import 'package:item_variance/models/item_type.dart';

import '../services/db_services.dart';

DBService dbService = DBService();

class ItemTypeProvider extends ChangeNotifier {
  //============================================================================Item Type List
  List<ItemType> _itemTypeList = [];
  //============================================================================Item Type Model Value Holder
  final ItemType _itemTypeHolder = ItemType();

  List<ItemType> get itemTypeList => _itemTypeList;
  ItemType get itemTypeHolder => _itemTypeHolder;

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
  Future<bool> addItemTypeProvider() async {
    try {
      //========================================================================Add Item Type Service
      bool result = await dbService.addItemTypeDbService(_itemTypeHolder);

      //========================================================================Get All Item Type to Refresh
      getAllItemTypeProvider();
      return result;
    } catch (e) {
      return false;
    }
  }

  //============================================================================Edit Item Type
  editItemTypeProvider(ItemType itemType) {
    //==========================================================================Assign Value to Model
    _itemTypeHolder.typeName = itemType.typeName;

    notifyListeners();
  }

  //============================================================================Save Edit Item Type
  Future<bool> updateItemTypeProvider() async {
    try {
      //========================================================================Update Item Type Service
      bool result = await dbService.updateItemTypeDbService(_itemTypeHolder);

      //========================================================================Get All Item Type to Refresh
      getAllItemTypeProvider();
      return result;
    } catch (e) {
      return false;
    }
  }

  //============================================================================Delete Item Type
  Future<bool> deleteItemTypeProvider(ItemType itemType) async {
    try {
      //========================================================================Delete Item Type
      bool result = await dbService.deleteItemTypeDbService(itemType);

      notifyListeners();
      return result;
    } catch (e) {
      return false;
    }
  }

  //============================================================================Item Type Cancel
  cancelItemType() {
    _itemTypeHolder.typeName = null;

    notifyListeners();
  }
}
