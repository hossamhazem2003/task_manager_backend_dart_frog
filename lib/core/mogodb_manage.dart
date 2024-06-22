import 'package:mongo_dart/mongo_dart.dart';

class DataBase {
  static Future<Db> createDb() async {
    final db = await Db.create(
      'mongodb+srv://hossamhazem:12345678910@backendtest1cluster.zodjjxa.mongodb.net/?retryWrites=true&w=majority&appName=backEndTest1Cluster',
    );

    if (!db.isConnected) {
      await db.open();
    }
    return db;
  }
}
