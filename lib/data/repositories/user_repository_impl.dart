import 'dart:convert';
import 'package:exchange_rate_app/data/models/currency_model.dart';
import 'package:exchange_rate_app/data/services/local_storage_service.dart';
import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<bool> login(String username, String secret) async {
    // реализация как в MockRepository тк нет реального API
    final condition = username == 'demo' && secret == 'demo';
    if (condition) {
      LocalStorageService.setUsername = username;
      LocalStorageService.setPassword = secret;
    }
    return condition;
  }

  @override
  Future logout() async {
    LocalStorageService.setUsername = '';
    LocalStorageService.setPassword = '';
  }

  @override
  Future addFavorites(List<CurrencyEntity> list) async {
    final currentFavs = await getFavorites();
    final favorites = [...list, ...currentFavs].toSet().toList().map<String>((el) {
      return (el as CurrencyModel).toJson().toString();
    }).toList();
    LocalStorageService.setFavorites = jsonEncode(favorites);
  }

  @override
  Future deleteFavorite(String id) async {
    final allFavorites = await getFavorites();
    final newFavorites = allFavorites.where((element) => element.id != id).toList();
    final favorites = newFavorites.map<String>((el) {
      return (el as CurrencyModel).toJson().toString();
    }).toList();
    LocalStorageService.setFavorites = jsonEncode(favorites);
  }

  @override
  Future<List<CurrencyEntity>> getFavorites() async {
    String? json = await LocalStorageService.getFavorites;
    if (json == null) return [];
    Iterable decodedJson = jsonDecode(json);
    List<CurrencyEntity> favorites = List<CurrencyEntity>.from(decodedJson.map((model) {
      model = model.replaceAll('{', '{"');
      model = model.replaceAll(': ', '": "');
      model = model.replaceAll(', ', '", "');
      model = model.replaceAll('}', '"}');
      return CurrencyModel.fromJson(jsonDecode(model));
    }));
    return favorites;
  }
}
