import 'dart:convert';

import 'package:auth/core/jwt_manage.dart';
import 'package:auth/core/mogodb_manage.dart';
import 'package:auth/models/user%20auth/user_signin_model.dart';
import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserSignInRepository {
  late final Db db;

  Future<UserSignIn> createUser(
    String? name,
    int? age,
    String? lastName,
    String? email,
    String? password,
  ) async {
    db = await DataBase.createDb();
    final usersCollection = db.collection('users');
    final encodedPassword = utf8.encode(password!);
    final hashedPassword = sha256.convert(encodedPassword).toString();
    final userId = const Uuid().v1();
    final user = UserSignIn(
      name: name,
      age: age,
      lastName: lastName,
      email: email,
      password: hashedPassword,
      userId: userId,
    );

    await usersCollection.insertOne(user.toJson());

    return user;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DataBase.createDb();
    final usersCollection = db.collection('users');
    final usersCursor = await usersCollection.find().toList();
    await db.close();
    return usersCursor;
  }

  Future<UserSignIn> getUserByToken(String accessToken) async {
    final userId = JwtManage.getUserIdFromToken(accessToken);
    final db = await DataBase.createDb();
    final usersCollection = db.collection('users');
    final user = await usersCollection.findOne(where.eq('userId', userId));
    final userModel = UserSignIn.fromJson(user!);
    return userModel;
  }

  Future<WriteResult> updateUserByID(
    String id,
    String name,
    int age,
    String email,
    String lastName,
    String password,
  ) async {
    final db = await DataBase.createDb();
    final usersCollection = db.collection('users');
    final encodedPassword = utf8.encode(password);
    final hashedPassword = sha256.convert(encodedPassword).toString();

    final result = await usersCollection.updateOne(
        where.eq('userId', id),
        modify
            .set('name', name)
            .set('age', age)
            .set('email', email)
            .set('lastName', lastName)
            .set('password', hashedPassword));
    await db.close();
    return result;
  }

  Future<Map<String, dynamic>?> getUserByID(String id) async {
    final db = await DataBase.createDb();
    final usersCollection = db.collection('users');
    final user = await usersCollection.findOne(where.eq('userId', id));
    await db.close();
    return user;
  }

  Future<void> deleteUser(String id) async {
    final db = await DataBase.createDb();
    final usersCollection = db.collection('users');
    await usersCollection.remove(where.eq('userId', id));
    await db.close();
  }

  Future<bool> checkGmail(String email) async {
    final users = await getAllUsers();
    for (final user in users) {
      final userEmail = user['email'] as String?;
      if (userEmail != null && userEmail == email) {
        return true;
      }
    }
    return false;
  }
}
