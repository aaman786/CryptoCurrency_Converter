import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utilities/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<dynamic> getAndroidDropdownButton() {
    // This is for the android device.
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<dynamic>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        getData();
        selectedCurrency = value;
      },
    );
  }

  CupertinoPicker getIOSpicker() {
    // This for IOS Devices.
    List<Text> pickerItem = [];
    for (String currency in currenciesList) {
      pickerItem.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (value) {
        getData();
        selectedCurrency = currenciesList[value];
        print(ValueKey);
      },
      children: pickerItem,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);

      isWaiting = false;
      setState(() {
        coinValues = data;
      });
      print(coinValues);
    } catch (e) {
      coinValues = {};
      print("Something went Wrong");
      print(e);
    }
  }

  void initState() {
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('🤑 Coin Ticker')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 160.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid
                ? getAndroidDropdownButton()
                : getIOSpicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final String? value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
