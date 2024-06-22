import 'package:mongo_dart/mongo_dart.dart';

class DataBase {
  static Future<Db> createDb() async {
    final db = await Db.create(
      'mongodb+srv://<username>:<password>@backendtest1cluster.zodjjxa.mongodb.net/?retryWrites=true&w=majority&appName=<cluster>',
    );

    if (!db.isConnected) {
      await db.open();
    }
    return db;
  }
}
