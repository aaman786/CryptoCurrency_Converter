import 'dart:convert';
import 'package:http/http.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData(selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      var requestURL = Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=BB7E2097-6B38-43C1-A91B-8B509B9BC9EA');
      Response response = await get(requestURL);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body)["rate"];
        double price = decodedData;
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem in connecting with the internet...';
      }
    }
    return cryptoPrices;
  }
}
