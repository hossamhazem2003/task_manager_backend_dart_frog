import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';

void main() {
  test('test crypto hash', () {
    const password = '12345679';
    // 12345678 --> ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f
    // 12345679 --> b759803bc6037a05e6564b6447a755b7f3862ba4d0d746785dbe133dcb6c8f4d
    final encodedPasswors = utf8.encode(password);
    final hashedPassword = sha256.convert(encodedPasswors).toString();
    print(hashedPassword);
  });
}
