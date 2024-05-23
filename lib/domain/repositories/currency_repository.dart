import 'package:exchange_rate_app/domain/entities/currency.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyEntity>> getRates();
}