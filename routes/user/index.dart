import 'dart:async';

import 'package:auth/core/exception.dart';
import 'package:auth/core/jwt_manage.dart';
import 'package:auth/repository/auth%20repository/user_signin_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getUser(context),
    _ => Future.value(Response(body: 'Default')),
  };
}

Future<Response> _getUser(RequestContext context) async {
  final userRepository = context.read<UserSignInRepository>();
  final accessToken = context.request.headers['Authorization']?.split(' ').last;

  if (accessToken == null || !JwtManage.verifyAccessToken(accessToken: accessToken)) {
    return Response.json(statusCode: 401, body: {'message': Exceptions.unauthorized});
  }

  try {
    final userId = JwtManage.getUserIdFromToken(accessToken);
    final user = await userRepository.getUserByID(userId);

    if (user == null) {
      return Response.json(statusCode: 404, body: {'message': Exceptions.userNotFound});
    }

    return Response.json(body: {'user': user});
  } catch (e) {
    return Response.json(statusCode: 500, body: {'message': 'Error retrieving user1: $e'});
  }
}
