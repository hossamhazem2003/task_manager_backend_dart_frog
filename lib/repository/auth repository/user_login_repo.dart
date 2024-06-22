import 'dart:convert';
import 'package:auth/core/jwt_manage.dart';
import 'package:auth/core/mogodb_manage.dart';
import 'package:auth/models/user%20auth/login_response_login.dart';
import 'package:auth/models/user%20auth/user_signin_model.dart';
import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserLoginRepository {
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DataBase.createDb();
    final usersCollection = db.collection('users');
    final usersCursor = await usersCollection.find().toList();
    await db.close();
    return usersCursor;
  }

  Future<Map<String, dynamic>?> userLogin(String? email, String? password) async {
    final db = await DataBase.createDb();
    final encodedPassword = utf8.encode(password!);
    final hashedPassword = sha256.convert(encodedPassword).toString();
    final user = await db.collection('users').findOne(
      where.eq('email', email).and(where.eq('password', hashedPassword)),
    );

    if (user == null) {
      return null;
    }

    final userModel = UserSignIn.fromJson(user);
    final accessToken = JwtManage.generateAccessToken(userId: userModel.userId);
    final loginResponseModel = LoginResponseModel(accessToken: accessToken);

    final userWithToken = <String, dynamic>{
      'token': loginResponseModel.accessToken,
      'user': userModel,
    };

    await db.close();
    return userWithToken;
  }
}
