import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static const secureStorage = FlutterSecureStorage();
  static get storage => GetStorage();

  static Future<void> clearSecureStorage () async => await secureStorage.deleteAll();

  static get getUsername async => await secureStorage.read(key: 'username');
  static set setUsername (String username) => secureStorage.write(key: 'username', value: username);

  static get getPassword async => await secureStorage.read(key: 'password');
  static set setPassword (String password) => secureStorage.write(key: 'password', value: password);

  static get getFavorites async => storage.read('favorites');
  static set setFavorites (String favorites) => storage.write('favorites', favorites);
}