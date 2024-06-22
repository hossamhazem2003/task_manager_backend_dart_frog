import 'package:auth/core/mogodb_manage.dart';
import 'package:auth/models/items/items_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ItemRepository {
  Future<ItemModel> addItem(
    String? itemName,
    String? backGroundColor,
    String userId,
  ) async {
    final db = await DataBase.createDb();
    final itemsCollection = db.collection('items');
    final itemId = const Uuid().v1();
    final item = ItemModel(
      itemId: itemId,
      itemName: itemName,
      color: backGroundColor,
      userId: userId,
    );
    await itemsCollection.insertOne(item.toJson());
    await db.close();
    return item;
  }

  Future<List<Map<String, dynamic>>> getItemsByUserId(String userId) async {
    final db = await DataBase.createDb();
    final itemsCollection = db.collection('items');
    final items = await itemsCollection.find(where.eq('userId', userId)).toList();
    await db.close();
    return items;
  }

  Future<void> deleteItemById(String itemId) async {
    final db = await DataBase.createDb();
    final itemsCollection = db.collection('items');
    await itemsCollection.remove(where.eq('itemId', itemId));
  }
}
