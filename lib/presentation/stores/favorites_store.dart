
import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/domain/repositories/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'favorites_store.g.dart';

class FavoritesStore = _FavoritesStore with _$FavoritesStore;

abstract class _FavoritesStore with Store {
  final UserRepository userRepository;

  _FavoritesStore(this.userRepository);

  Future<void> addFavorites(List<CurrencyEntity> list) async {
    userRepository.addFavorites(list);
  }

  Future<List<CurrencyEntity>> getFavorites() async {
    final result = await userRepository.getFavorites();
    result.sort((a, b) {
      return a.symbol.compareTo(b.symbol);
    });
    return result;
  }

  Future deleteFavorites(String id) async {
    await userRepository.deleteFavorite(id);
  }
}