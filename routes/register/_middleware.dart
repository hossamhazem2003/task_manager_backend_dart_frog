import 'package:auth/repository/auth%20repository/user_signin_repo.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(
    bearerAuthentication<Map<String, dynamic>>(
      authenticator: (context, token) async{
        final userRepository = context.read<UserSignInRepository>();
        return userRepository.getUserByID(token);
      },
      applies: (RequestContext context) async =>
              context.request.method != HttpMethod.post,
    ),
  ).use(
    provider<UserSignInRepository>(
      (context) => UserSignInRepository(),
    ),
  );
}
