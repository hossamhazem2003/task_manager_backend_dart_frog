// ignore_for_file: avoid_dynamic_calls

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtManage {
  static const _secretKey = 'QBBS0P1H2NLLOTVRWIHR6WXI55G2ZYHH';

  static String generateAccessToken({required String userId}) {
    final jwt = JWT({'userId': userId});
    return jwt.sign(SecretKey(_secretKey));
  }

  static bool verifyAccessToken({required String accessToken}) {
    try {
      JWT.verify(accessToken, SecretKey(_secretKey));
      return true;
    } catch (e) {
      return false;
    }
  }

  static String getUserIdFromToken(String token) {
    final jwt = JWT.verify(token, SecretKey(_secretKey));
    return jwt.payload['userId'] as String;
  }
}











//QBBS0P1H2NLLOTVRWIHR6WXI55G2ZYHH
//KF4DMA5VAYCGM60T7N0A46BLOEHXSNX7