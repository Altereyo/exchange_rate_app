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
  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {

  final store = getIt.get<CurrencyStore>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  String _fromCurrency = 'BTC';
  String _toCurrency = 'RUB';
  String _withoutComission = '';

  void _convert() {
    if (_amountController.text.isEmpty) return;

    final amountText = _amountController.text.replaceAll(',', '');
    final amount = Decimal.tryParse(amountText);
    if (amount == null) return;

    final fromRate = Decimal.parse(store.rates.firstWhere((rate) => rate.symbol == _fromCurrency).rateUsd.toString());
    final toRate = Decimal.parse(store.rates.firstWhere((rate) => rate.symbol == _toCurrency).rateUsd.toString());

    if (fromRate == Decimal.zero || toRate == Decimal.zero) return;

    final result = (amount * fromRate) / toRate;
    final resultWithCommission = result.toDouble() * 1.03;

    final isFiat = _toCurrency == 'USD' || _toCurrency == 'EUR' || _toCurrency == 'RUB'; // Add other FIAT currencies as needed

    final formattedResult = isFiat
        ? ((resultWithCommission.toDouble() * 100).floor() / 100).toStringAsFixed(2)
        : resultWithCommission.toDouble().toStringAsFixed(18);

    setState(() {
      _withoutComission = result.toDouble().toString();
      _resultController.text = formattedResult;
    });
  }

  @override
  void initState() {
    getIt.get<CurrencyStore>()
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
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      if (v.isEmpty) {
                        setState(() {
                          _resultController.text = '';
                        });
                      }
                      _convert();
                    },
                    label: 'У меня есть',
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: _fromCurrency,
                    onChanged: (value) {
                      if (value! == _toCurrency) return;
                      setState(() {
                        _fromCurrency = value;
                        _convert();
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
                    controller: _resultController,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    label: 'Хочу приобрести',
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: _toCurrency,
                    onChanged: (value) {
                      if (value! == _fromCurrency) return;
                      setState(() {
                        _toCurrency = value;
                        _convert();
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
            if (_amountController.text.isNotEmpty) Container(
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
                    _withoutComission.toString(),
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