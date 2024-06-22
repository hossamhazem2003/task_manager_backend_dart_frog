import 'dart:async';
import 'dart:io';
import 'package:auth/core/exception.dart';
import 'package:auth/models/user%20auth/user_login_model.dart';
import 'package:auth/repository/auth%20repository/user_login_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _userLogin(context),
    _ => Future.value(Response(
      statusCode: HttpStatus.badRequest,
      body: 'Please try the correct request!',
    ),)
  };
}

Future<Response> _userLogin(RequestContext context) async {
  final userLoginRepository = UserLoginRepository();
  final json = (await context.request.json()) as Map<String, dynamic>;
  final user = UserLoginModel.fromJson(json);

  if (user.name == null || user.password == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'message': Exceptions.allParametarsRequired},
    );
  }

  final response = await userLoginRepository.userLogin(user.name, user.password);

  if (response == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'message': Exceptions.userNotFound},
    );
  }

  return Response.json(
    body: {
      'message': 'user login correctly',
      'user': response,
    },
  );
}
