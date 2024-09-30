import 'package:encrypt/encrypt.dart';

class EncryptionAndDecryption {
  static encryptAES(text) {
    final key = Key.fromUtf8('1203199320052021');
    final iv = IV.fromUtf8('1203199320052021');
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static decryptAES(text) {
    final key = Key.fromUtf8('1203199320052021');
    final iv = IV.fromUtf8('1203199320052021');
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    return encrypter.decrypt64(text, iv: iv);
  }
}
