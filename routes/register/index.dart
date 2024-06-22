import 'dart:async';
import 'dart:io';
import 'package:auth/core/exception.dart';
import 'package:auth/repository/auth%20repository/user_signin_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _createUser(context),
    _ => Future.value(Response(body: 'Please enter correct request'))
  };
}

Future<Response> _createUser(RequestContext context) async {
  try {
    final userRepository = context.read<UserSignInRepository>();
    final json = (await context.request.json()) as Map<String, dynamic>;
    final name = json['name'] as String?;
    final age = json['age'] as int?;
    final lastName = json['lastName'] as String?;
    final password = json['password'] as String?;
    final email = json['email'] as String?;

    if (name == null ||
        age == null ||
        email == null ||
        lastName == null ||
        password == null) {
      return Response.json(
        body: {
          'message': Exceptions.allParametarsRequired,
        },
        statusCode: HttpStatus.badRequest,
      );
    }

    if (!email.contains('@') || !email.contains('.')) {
      return Response.json(
        body: {
          'message': Exceptions.correctGmail,
        },
        statusCode: HttpStatus.badRequest,
      );
    }

    if (await userRepository.checkGmail(email)) {
      return Response.json(
        body: {
          'message': Exceptions.emailUsedBefore,
        },
        statusCode: HttpStatus.conflict,
      );
    }

    final user = await userRepository.createUser(name, age, lastName, email, password);

    return Response.json(
      body: {
        'message': 'Data saved correctly',
        'user': user,
      },
    );
  } catch (e) {
    return Response.json(
      body: {
        'message': 'An error occurred while creating the user: $e',
      },
      statusCode: HttpStatus.internalServerError,
    );
  }
}
