import 'dart:convert';
import 'package:exchange_rate_app/data/models/currency_model.dart';
import 'package:exchange_rate_app/domain/repositories/currency_repository.dart';
import 'package:http/http.dart' as http;

class CurrencyRepositoryImpl implements CurrencyRepository {
  @override
  Future<List<CurrencyModel>> getRates() async {
    final response = await http.get(Uri.parse('https://api.coincap.io/v2/rates'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((item) => CurrencyModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load rates');
    }
  }
}
