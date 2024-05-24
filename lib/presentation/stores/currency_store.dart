import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/domain/repositories/currency_repository.dart';
import 'package:exchange_rate_app/internal/enum/sort_by.dart';
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

  SortBy sortBy = SortBy.alphabetAsc;

  @action
  Future<void> sortRates() async {
    switch(sortBy) {
      case SortBy.alphabetAsc:
        rates.sort((a, b) {
          return a.symbol.compareTo(b.symbol);
        });
        break;
      case SortBy.alphabetDesc:
        rates.sort((a, b) {
          return b.symbol.compareTo(a.symbol);
        });
        break;
      case SortBy.valueAsc:
        rates.sort((a, b) {
          return a.rateUsd.compareTo(b.rateUsd);
        });
        break;
      case SortBy.valueDesc:
        rates.sort((a, b) {
          return b.rateUsd.compareTo(a.rateUsd);
        });
        break;
    }
  }
  @action
  Future<void> getRates() async {
    isLoading = true;
    try {
      var result = await currencyRepository.getRates();
      rates = ObservableList.of(result);
      await sortRates();
    } finally {
      isLoading = false;
    }
  }
}