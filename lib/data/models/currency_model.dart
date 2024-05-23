import 'package:exchange_rate_app/domain/entities/currency.dart';

class CurrencyModel extends CurrencyEntity {
  CurrencyModel({required super.id, required super.rateUsd, required super.symbol});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'],
      rateUsd: double.parse(json['rateUsd']),
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rateUsd': rateUsd.toString(),
      'symbol': symbol,
    };
  }
}
