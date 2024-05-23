import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/domain/repositories/currency_repository.dart';
import 'package:mobx/mobx.dart';

part 'currency_store.g.dart';

class CurrencyStore = _CurrencyStore with _$CurrencyStore;

abstract class _CurrencyStore with Store {
  final CurrencyRepository currencyRepository;

  _CurrencyStore(this.currencyRepository);

  @observable
  ObservableList<CurrencyEntity> rates = ObservableList<CurrencyEntity>();

  @observable
  bool isLoading = false;

  @action
  Future<void> getRates() async {
    isLoading = true;
    try {
      var result = await currencyRepository.getRates();
      result.sort((a, b) {
        return a.symbol.compareTo(b.symbol);
      });
      rates = ObservableList.of(result);
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
    }
  }
}