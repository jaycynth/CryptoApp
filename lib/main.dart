import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() async {

  List currencies = await getCurrencies();
  print(currencies);

  runApp(new MaterialApp(
    //sets the theme color of the app
    theme: new ThemeData(primarySwatch: Colors.pink),
    home: new Center(
      child: new CryptoListWidget(currencies),
    ),
  ));
}

//method to fetch the json data from the API
Future<List> getCurrencies() async {
  String cryptoUrl = 'https://api.coinmarketcap.com/v1/ticker/?limit=50';
  //the await expression evaluates the http.get() and suspends the currently getCurrencies()
  //until the result is ready to be decoded
  http.Response response = await http.get(cryptoUrl);
  return json.decode(response.body);
}

class CryptoListWidget extends StatelessWidget {
  //variables are private;inaccessible to other classes
  //variables in stateless widget should be final
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];
  final List _currencies;

//constructor;assigning the value passed to the constructor to the _currencies variable
  CryptoListWidget(this._currencies);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Crypto App"),
      ),
      body: _cryptoWidget(),
    );
  }

  Widget _cryptoWidget() {
    return new Container(
      child: new Column(
        // A column widget can have several widgets that are placed in a top down fashion
        children: <Widget>[_getListViewWidget()],
      ),
    );
  }



  Widget _getListViewWidget() {
    // the ListView should have the flexibility to expand to fill the available space in the vertical axis
    return new Flexible(
        child: new ListView.builder(
          // The number of items to show
            itemCount: _currencies.length,
            // Callback that should return ListView children
            // The index parameter = 0...(itemCount-1)
            itemBuilder: (BuildContext context, int index) {
              // Get the currency at this position
              final Map currency = _currencies[index];

              // Get the icon color. Since x mod y, will always be less than y,
              // this will be within bounds
              final MaterialColor color = _colors[index % _colors.length];

              return _getListItemWidget(currency, color);
            }));
  }

  CircleAvatar _getLeadingWidget(String currencyName, MaterialColor color) {
    return new CircleAvatar(
      backgroundColor: color,
      child: new Text(currencyName[0]),
    );
  }

  Text _getTitleWidget(String currencyName) {
    return new Text(
      currencyName,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  RichText _getSubtitleText(String priceUsd, String percentChange1h) {
    TextSpan priceTextWidget = new TextSpan(text: "\$$priceUsd\n", style:
    new TextStyle(color: Colors.black),);
    String percentChangeText = "1 hour: $percentChange1h%";
    TextSpan percentChangeTextWidget;

    if(double.parse(percentChange1h) > 0) {
      // Currency price increased. Color percent change text green
      percentChangeTextWidget = new TextSpan(text: percentChangeText,
        style: new TextStyle(color: Colors.green),);
    }
    else {
      // Currency price decreased. Color percent change text red
      percentChangeTextWidget = new TextSpan(text: percentChangeText,
        style: new TextStyle(color: Colors.red),);
    }

    return new RichText(text: new TextSpan(
        children: [
          priceTextWidget,
          percentChangeTextWidget
        ]
    ),);
  }

  ListTile _getListTile(Map currency, MaterialColor color) {
    return new ListTile(
      leading: _getLeadingWidget(currency['name'], color),
      title: _getTitleWidget(currency['name']),
      subtitle: _getSubtitleText(
          currency['price_usd'], currency['percent_change_1h']),
      isThreeLine: true,
    );
  }

  Widget _getListItemWidget(Map currency, MaterialColor color) {
    return _getListTile(currency, color);


  }

}