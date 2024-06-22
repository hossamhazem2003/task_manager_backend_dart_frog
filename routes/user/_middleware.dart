import 'dart:developer';

import 'package:auth/core/exception.dart';
import 'package:auth/core/jwt_manage.dart';
import 'package:auth/repository/auth%20repository/user_signin_repo.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<UserSignInRepository>((context) => UserSignInRepository()))
      .use((innerHandler) {
    return (requestContext) async {
      final authHeader = requestContext.request.headers['Authorization'];
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7);
        if (JwtManage.verifyAccessToken(accessToken: token)) {
          try {
            final jwt = JWT.verify(token, SecretKey('QBBS0P1H2NLLOTVRWIHR6WXI55G2ZYHH'));
            requestContext = requestContext.provide<JWT>(() => jwt);
            return await innerHandler(requestContext);
          } catch (e) {
            log('Token verification failed: $e');
          }
        }
      }
      return Response.json(statusCode: 401, body: {'message': Exceptions.unauthorized});
    };
  });
}
