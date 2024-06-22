import 'dart:async';
import 'dart:io';

import 'package:auth/core/exception.dart';
import 'package:auth/models/user%20auth/user_signin_model.dart';
import 'package:auth/repository/auth%20repository/user_signin_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.delete => _deleteUser(context, id),
    HttpMethod.put => _updateUserByID(context, id),
    _ => Future.value(
        Response(statusCode: HttpStatus.badRequest, body: 'Bad request'),
      ),
  };
}

Future<Response> _updateUserByID(RequestContext context, String id) async {
  try {
    final userRepository = context.read<UserSignInRepository>();

    final json = (await context.request.json()) as Map<String, dynamic>;
    final name = json['name'] as String?;
    final age = json['age'] as int?;
    final lastName = json['lastName'] as String?;
    final password = json['password'] as String?;
    final email = json['email'] as String?;
    final user = UserSignIn(name: name, age: age, lastName: lastName, password: password, email: email, userId: '');
    final result = await userRepository.updateUserByID(
      id,
      user.name!,
      user.age!,
      user.email!,
      user.lastName!,
      user.password!,
    );
    if (result.nModified == 0) {
      return Response.json(
        statusCode: 404,
        body: {'message': Exceptions.userNotFound},
      );
    }

    return Response.json(
      body: {'message': 'User data updated successfully'},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'message': 'An error occurred', 'error': e.toString()},
    );
  }
}

Future<Response> _deleteUser(RequestContext context, String id) async {
  final userRepository = context.read<UserSignInRepository>();
  await userRepository.deleteUser(id);
  return Response.json(
    body: {
      'message': 'user deleated correctly',
    },
  );
}
