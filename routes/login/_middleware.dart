import 'package:auth/repository/auth%20repository/user_login_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<UserLoginRepository>((context) => UserLoginRepository()));
}
