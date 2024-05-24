import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static const secureStorage = FlutterSecureStorage();
  static get getStorage => GetStorage();

  static Future<void> clearSecureStorage () async => await secureStorage.deleteAll();

  static get getUsername async => kIsWeb ? getStorage.read('username') : await secureStorage.read(key: 'username');
  static set setUsername (String username) => kIsWeb ? getStorage.write('username', username) : secureStorage.write(key: 'username', value: username);

  static get getPassword async => kIsWeb ? getStorage.read('password') : await secureStorage.read(key: 'password');
  static set setPassword (String password) => kIsWeb ? getStorage.write('password', password) : secureStorage.write(key: 'password', value: password);

  static get getFavorites async => getStorage.read('favorites');
  static set setFavorites (String favorites) => getStorage.write('favorites', favorites);
}