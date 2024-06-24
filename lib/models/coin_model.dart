class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String nameid;
  final int rank;
  final String price_usd;
  final String percent_change_24h;
  final String percent_change_1h;
  final String percent_change_7d;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.nameid,
    required this.rank,
    required this.price_usd,
    required this.percent_change_24h,
    required this.percent_change_1h,
    required this.percent_change_7d,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      nameid: json['nameid'],
      rank: json['rank'],
      price_usd: json['price_usd'],
      percent_change_24h: json['percent_change_24h'] ?? '',
      percent_change_1h: json['percent_change_1h'] ?? '',
      percent_change_7d: json['percent_change_7d'] ?? '',
    );
  }

  @override
  String toString() {
    return 'CoinModel{id: $id, symbol: $symbol, name: $name, rank: $rank}';
  }
}
