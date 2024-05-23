import 'package:exchange_rate_app/data/repositories/user_repository_impl.dart';
import 'package:exchange_rate_app/data/repositories/currency_repository_impl.dart';
import 'package:exchange_rate_app/domain/repositories/user_repository.dart';
import 'package:exchange_rate_app/domain/repositories/currency_repository.dart';
import 'package:exchange_rate_app/presentation/stores/auth_store.dart';
import 'package:exchange_rate_app/presentation/stores/currency_store.dart';
import 'package:exchange_rate_app/presentation/stores/favorites_store.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerSingleton<CurrencyRepository>(CurrencyRepositoryImpl());
  getIt.registerSingleton<UserRepository>(UserRepositoryImpl());
  getIt.registerSingleton<AuthStore>(AuthStore(getIt.get()));
  getIt.registerSingleton<CurrencyStore>(CurrencyStore(getIt.get())).getRates();
  getIt.registerSingleton<FavoritesStore>(FavoritesStore(getIt.get()));
}