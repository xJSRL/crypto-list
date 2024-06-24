import 'dart:convert';

import 'package:crypto_price_list/models/coin_model.dart';
import 'package:http/http.dart' as http;

class Repository {
  final String apiBaseUri = 'https://api.coinlore.net/api/';

  Future<List<CoinModel>> getAllCoins(int pageNumber, int limit) async {

    String endpoint = 'tickers/';

    var response = await http.get(Uri.parse('$apiBaseUri$endpoint?start=$pageNumber&limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body)['data'];

      final data = jsonData.map((jsonData) => CoinModel.fromJson(jsonData)).toList();
      // print('response: $jsonData');
      return data;
    } else {
      throw 'Error on getAllCoins()';
    }
  }
}
