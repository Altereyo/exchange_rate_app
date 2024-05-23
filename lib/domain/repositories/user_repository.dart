import 'package:exchange_rate_app/domain/entities/currency.dart';

abstract class UserRepository {
  Future<bool> login(String username, String secret);
  Future logout();

  Future addFavorites(List<CurrencyEntity> list);
  Future deleteFavorite(String id);
  Future<List<CurrencyEntity>> getFavorites();
}