import 'dart:typed_data';

import 'package:argon2/argon2.dart';

String hash(String password, String salt) {
  var parameters = Argon2Parameters(
    Argon2Parameters.ARGON2_i,
    salt.toBytesLatin1(),
    version: Argon2Parameters.ARGON2_VERSION_10,
    iterations: 1,
  );

  var argon2 = Argon2BytesGenerator();

  argon2.init(parameters);

  var passwordBytes = parameters.converter.convert(password);

  var result = Uint8List(32);
  argon2.generateBytes(passwordBytes, result, 0, result.length);

  var resultHex = result.toHexString();

  return resultHex;
}
