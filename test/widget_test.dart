import 'package:exchange_rate_app/data/repositories/currency_repository_impl.dart';
import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/internal/di.dart';
import 'package:exchange_rate_app/presentation/screens/exchange.dart';
import 'package:exchange_rate_app/presentation/stores/currency_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';

void main() {
  setupDI();
  testWidgets('ConversionScreen Test', (WidgetTester tester) async {
    final currencyStore = CurrencyStore(CurrencyRepositoryImpl());
    currencyStore.rates = ObservableList.of([
      CurrencyEntity(id: 'BTC', symbol: 'BTC', rateUsd: 30000),
      CurrencyEntity(id: 'RUB', symbol: 'RUB', rateUsd: 0.013),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ConversionScreen(currencyStore: currencyStore),
      ),
    );

    expect(find.byKey(const ValueKey('currency_from')), findsOneWidget);
    expect(find.byKey(const ValueKey('currency_to')), findsOneWidget);

    final input = find.byType(TextField).first;
    await tester.enterText(input, '1');
    await tester.pump();

    // Verify conversion result
    final result = find.byKey(const ValueKey('result_comission'));
    expect(result, findsOneWidget);
  });
}
