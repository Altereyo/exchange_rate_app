import 'package:exchange_rate_app/data/services/local_storage_service.dart';
import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/domain/repositories/user_repository.dart';

class UserRepositoryMock implements UserRepository {
  @override
  Future<bool> login(String username, String secret) async {
    final condition = username == 'demo' && secret == 'demo';
    if (condition) {
      LocalStorageService.setUsername = username;
      LocalStorageService.setPassword = secret;
    }
    return condition;
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future addFavorites(List<CurrencyEntity> list) {
    // TODO: implement addFavorite
    throw UnimplementedError();
  }

  @override
  Future deleteFavorite(String id) {
    // TODO: implement deleteFavorite
    throw UnimplementedError();
  }

  @override
  Future<List<CurrencyEntity>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }
}
