import 'package:exchange_rate_app/internal/di.dart';
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
  double _withoutComission = 0.0;


  void _convert() {
    if (_amountController.text.isEmpty) return;

    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    final fromRate = store.rates.firstWhere((rate) => rate.symbol == _fromCurrency).rateUsd;
    final toRate = store.rates.firstWhere((rate) => rate.symbol == _toCurrency).rateUsd;

    if (fromRate == 0 || toRate == 0) return;

    final result = (amount * fromRate / toRate);
    final resultWithCommission = result * 1.03;

    setState(() {
      _withoutComission = result;
      _resultController.text = resultWithCommission.toString();
    });
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
                    onChanged: (v) => _convert(),
                    label: 'У меня есть',
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: _fromCurrency,
                    onChanged: (value) {
                      setState(() {
                        _fromCurrency = value!;
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
                      setState(() {
                        _toCurrency = value!;
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