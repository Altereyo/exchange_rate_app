import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:exchange_rate_app/internal/di.dart';
import 'package:exchange_rate_app/internal/enum/sort_by.dart';
import 'package:exchange_rate_app/presentation/shared/app_colors.dart';
import 'package:exchange_rate_app/presentation/shared/app_styles.dart';
import 'package:exchange_rate_app/presentation/stores/currency_store.dart';
import 'package:exchange_rate_app/presentation/widgets/input.dart';
import 'package:flutter/material.dart';

class ConversionScreen extends StatefulWidget {
  final CurrencyStore? currencyStore;

  const ConversionScreen({super.key, this.currencyStore});
  @override
  ConversionScreenState createState() => ConversionScreenState();
}

class ConversionScreenState extends State<ConversionScreen> {

  CurrencyStore store = getIt.get<CurrencyStore>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController resultController = TextEditingController();

  String fromCurrency = 'BTC';
  String toCurrency = 'RUB';
  String withoutComission = '';

  void convert(CurrencyStore _store) {
    if (amountController.text.isEmpty) return;

    final amountText = amountController.text.replaceAll(',', '');
    final amount = Decimal.tryParse(amountText);
    if (amount == null) return;

    final fromRate = Decimal.parse(_store.rates.firstWhere((rate) => rate.symbol == fromCurrency).rateUsd.toString());
    final toRate = Decimal.parse(_store.rates.firstWhere((rate) => rate.symbol == toCurrency).rateUsd.toString());

    if (fromRate == Decimal.zero || toRate == Decimal.zero) return;

    final result = (amount * fromRate) / toRate;
    final resultWithCommission = result.toDouble() * 1.03;

    final isFiat = toCurrency == 'USD' || toCurrency == 'EUR' || toCurrency == 'RUB'; // Add other FIAT currencies as needed

    final formattedResult = isFiat
        ? ((resultWithCommission.toDouble() * 100).floor() / 100).toStringAsFixed(2)
        : resultWithCommission.toDouble().toStringAsFixed(18);

    setState(() {
      withoutComission = result.toDouble().toString();
      resultController.text = formattedResult;
    });
  }

  @override
  void initState() {
    if (widget.currencyStore != null) store = widget.currencyStore!;
    store
      ..sortBy = SortBy.alphabetAsc
      ..sortRates();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Конвертация валют', style: AppStyles.appBarText)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: AppInput(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      if (v.isEmpty) {
                        setState(() {
                          resultController.text = '';
                        });
                      }
                      convert(store);
                    },
                    label: 'У меня есть',
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    key: ValueKey('currency_from'),
                    value: fromCurrency,
                    onChanged: (value) {
                      if (value! == toCurrency) return;
                      setState(() {
                        fromCurrency = value;
                        convert(store);
                      });
                    },
                    items: store.rates.map((rate) {
                      return DropdownMenuItem<String>(
                        value: rate.symbol,
                        child: Text(rate.symbol),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: AppInput(
                    controller: resultController,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    label: 'Хочу приобрести',
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    key: ValueKey('currency_to'),
                    value: toCurrency,
                    onChanged: (value) {
                      if (value! == fromCurrency) return;
                      setState(() {
                        toCurrency = value;
                        convert(store);
                      });
                    },
                    items: store.rates.map((rate) {
                      return DropdownMenuItem<String>(
                        value: rate.symbol,
                        child: Text(rate.symbol),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (amountController.text.isNotEmpty) Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Без комиссии в 3% сумма составляет:',
                    style: AppStyles.smallFatText.copyWith(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    withoutComission.toString(),
                    key: const ValueKey('result_comission'),
                    style: AppStyles.smallFatText,
                  ),
                ],
              ),
            ),
            // TotalWidget(),
          ],
        ),
      ),
    );
  }
}