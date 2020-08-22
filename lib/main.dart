import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: CurrencyConvert(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

class CurrencyConvert extends StatefulWidget {
  CurrencyConvert({Key Key, this.title}) : super(key: key);
  final String title;

  @override
  _CurrencyConvertState createState() => _CurrencyConvertState();
}

class _CurrencyConvertState extends State<CurrencyConvert> {
  final fromController = TextEditingController();
  List<String> Currency;
  String fromCurrency = "INR";
  String toCurrency = "USD";

  @override
  void initState() {
    super.initState();
    loadCurrency();
  }

  Future<String> loadCurrency() async {
    String uri = "https://api.exchangeratesapi.io/latest?base=USD&symbols=INR";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map cuMap = responseBody['rates'];
    Currency = cuMap.keys.toList();
    print(Currency);
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Enter The Amount In INR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter Here'),
              controller: fromController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            trailing: Text('INR'),
          ),
          IconButton(
            icon: Icon(Icons.arrow_drop_down_circle),
          ),
          Text(
            'The Amount In USD =',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Chip(
              label: Text(
                "                                       ",
              ),
            ),
            trailing: Text('USD'),
          ),
        ],
      ),
    );
  }

  Widget _buildDropDownButton(String currencylist) {
    return DropdownButton(

    );
}
