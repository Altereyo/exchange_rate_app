// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CurrencyStore on _CurrencyStore, Store {
  late final _$ratesAtom = Atom(name: '_CurrencyStore.rates', context: context);

  @override
  ObservableList<CurrencyEntity> get rates {
    _$ratesAtom.reportRead();
    return super.rates;
  }

  @override
  set rates(ObservableList<CurrencyEntity> value) {
    _$ratesAtom.reportWrite(value, super.rates, () {
      super.rates = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_CurrencyStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$sortRatesAsyncAction =
      AsyncAction('_CurrencyStore.sortRates', context: context);

  @override
  Future<void> sortRates() {
    return _$sortRatesAsyncAction.run(() => super.sortRates());
  }

  late final _$getRatesAsyncAction =
      AsyncAction('_CurrencyStore.getRates', context: context);

  @override
  Future<void> getRates() {
    return _$getRatesAsyncAction.run(() => super.getRates());
  }

  @override
  String toString() {
    return '''
rates: ${rates},
isLoading: ${isLoading}
    ''';
  }
}
