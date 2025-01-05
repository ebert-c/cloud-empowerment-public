import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypt/crypt.dart';
import 'package:steel_crypt/steel_crypt.dart';

class CryptoToken {
  String salt;
  String hash;

  CryptoToken({
    required this.salt,
    required this.hash
  });
}

class CryptoHelper {
  CryptoHelper();

  static String getEncryptionKey() {
    return encrypt.Key.fromSecureRandom(128).base64;
  }

  static String getKeyEncryptionKey(String password, String salt) {
    PassCrypt keyEncryptionKeyGenerator = PassCrypt.pbkdf2(algo: HmacHash.Sha3_256);
    return keyEncryptionKeyGenerator.hash(salt: salt, inp: password, len: 128);
  }

  static String encryptKey(String key, String password, IV iv, String salt) {
    String keyEncryptionKey = Key.fromBase64(getKeyEncryptionKey(password, salt)).base64;
    Encrypter keyEncryptionKeyEncrypter = Encrypter(AES(Key.fromBase64(keyEncryptionKey)));
    return keyEncryptionKeyEncrypter.encrypt(key, iv: iv).base64;
  }

  static String decryptKey(String key, String password, IV iv, String salt) {
    String keyEncryptionKey = Key.fromBase64(getKeyEncryptionKey(password, salt)).base64;
    Encrypter keyEncryptionKeyEncrypter = Encrypter(AES(Key.fromBase64(keyEncryptionKey)));
    return keyEncryptionKeyEncrypter.decrypt(Encrypted.fromBase64(key), iv: iv);
  }

  static bool passwordMatches(String password, String salt, String storedPassword) {
    return Crypt.sha256(password, salt: salt).match(storedPassword);
  }

  static CryptoToken hashAndSaltPassword(String password) {
    String salt = SecureRandom(32).utf8;
    String hash = Crypt.sha256(password+salt, salt: salt).toString();
    return new CryptoToken(salt: salt, hash: hash);
  }

  static Map<String, dynamic> encryptJson(var json, String password, String key, String salt) {

    encrypt.Key encryptionKey = encrypt.Key.fromBase64(key);
    Encrypter encrypter = Encrypter(AES(encryptionKey));
    final iv = IV.fromLength(32);

    for (String jsonKey in json.keys) {
      json[jsonKey] = encrypter.encrypt(json[jsonKey], iv: iv);
    }
    json['iv'] = iv.base64;

    return json;
  }

  static Map<String, dynamic> decryptJson(Map<String, dynamic> json, String password, String key, String salt) {

    encrypt.Key encryptionKey = encrypt.Key.fromBase64(key);
    encrypt.Encrypter encrypter = Encrypter(AES(encryptionKey));
    final iv = IV.fromBase64(json['iv']);

    for (String key in json.keys) {
      json[key] = encrypter.decrypt(json[key], iv: iv);
    }

    return json;
  }
}
