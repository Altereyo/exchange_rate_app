class CurrencyEntity {
  final String id;
  final String symbol;
  final double rateUsd;

  CurrencyEntity({required this.id, required this.symbol, required this.rateUsd});

  @override
  String toString() {
    return 'CurrencyEntity{id: $id, symbol: $symbol, rateUsd: $rateUsd}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrencyEntity &&
        other.id == id &&
        other.symbol == symbol;
  }

  @override
  int get hashCode => id.hashCode ^ symbol.hashCode;
}
