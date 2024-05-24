import 'package:exchange_rate_app/data/repositories/currency_repository_impl.dart';
import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/presentation/stores/currency_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';

void main() {
  group('CurrencyStore', () {
    late CurrencyStore store;

    setUp(() {
      store = CurrencyStore(CurrencyRepositoryImpl());
      store.rates = ObservableList.of([
        CurrencyEntity(id: 'USD', symbol: 'USD', rateUsd: 1),
        CurrencyEntity(id: 'RUB', symbol: 'RUB', rateUsd: 0.013),
        CurrencyEntity(id: 'BTC', symbol: 'BTC', rateUsd: 30000),
      ]);
    });

    test('converts currencies correctly', () {
      final amount = Decimal.parse('100');
      final fromRate = Decimal.parse(store.rates.firstWhere((rate) => rate.symbol == 'USD').rateUsd.toString());
      final toRate = Decimal.parse(store.rates.firstWhere((rate) => rate.symbol == 'RUB').rateUsd.toString());

      final result = (amount * fromRate) / toRate;
      final resultWithCommission = result.toDouble() * 1.03;

      expect(resultWithCommission.toString(), '7923.076923076924');
    });

    test('handles large values correctly', () {
      final amount = Decimal.parse('6.704773729722327e+22');
      final fromRate = Decimal.parse(store.rates.firstWhere((rate) => rate.id == 'BTC').rateUsd.toString());
      final toRate = Decimal.parse(store.rates.firstWhere((rate) => rate.id == 'USD').rateUsd.toString());

      final result = (amount * fromRate) / toRate;
      final resultWithCommission = result.toDouble() * 1.03;

      expect(resultWithCommission.toString(), '2.0717750824841991e+27');
    });
  });
}