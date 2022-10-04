import '../constant/constant_text.dart';
import '../models/item_type.dart';
import '../utils/db_helper.dart';

class DBService {
  //============================================================================GET ITEM TYPE
  Future<List<ItemType>> getAllItemTypeDbService() async {
    try {
      //========================================================================Call Initialize DB Helper
      await DBHelper.init();

      //========================================================================Query Table to Fetch Data
      List<Map<String, dynamic>> itemTypeList =
          await DBHelper.query(TableName.itemType);

      return itemTypeList.map((e) => ItemType.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  //============================================================================ADD ITEM TYPE
  Future<bool> addItemTypeDbService(ItemType itemType) async {
    try {
      //========================================================================Call Initialize DB Helper
      await DBHelper.init();

      //========================================================================Call Insert Method
      int result = await DBHelper.insert(TableName.itemType, itemType);

      return result > 0 ? true : false;
    } catch (e) {
      return false;
    }
  }

  //============================================================================UPDATE ITEM TYPE
  Future<bool> updateItemTypeDbService(ItemType itemType) async {
    try {
      //========================================================================Call Initialize DB Helper
      await DBHelper.init();

      //========================================================================Call Update Method
      int result = await DBHelper.update(TableName.itemType, itemType);

      return result > 0 ? true : false;
    } catch (e) {
      return false;
    }
  }

  //============================================================================DELETE ITEM TYPE
  Future<bool> deleteItemTypeDbService(ItemType itemType) async {
    try {
      //========================================================================Call Initializer
      await DBHelper.init();

      //========================================================================Call Delete Method
      int result = await DBHelper.delete(TableName.itemType, itemType);

      return result > 0 ? true : false;
    } catch (e) {
      return false;
    }
  }
}
