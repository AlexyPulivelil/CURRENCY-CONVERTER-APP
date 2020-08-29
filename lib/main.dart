import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: "Currency Converter",
    home: CurrencyConvert(),
  ));
}

class CurrencyConvert extends StatefulWidget {
  @override
  _CurrencyConvertState createState() => _CurrencyConvertState();
}

class _CurrencyConvertState extends State<CurrencyConvert> {
  final fromTextController = TextEditingController();
  List<String> currency;
  String fromCurrency = "USD";
  String toCurrency = "INR";
  String result;

  @override
  void initState() {
    super.initState();
    loadCurrency();
  }

  Future<String> loadCurrency() async {
    String uri = "https://api.exchangeratesapi.io/latest";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    currency = curMap.keys.toList();
    setState(() {});
    print(currency);
    return "Success";
  }

  Future<String> _doConversion() async {
    String uri =
        "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    setState(() {
      result = (double.parse(fromTextController.text) *
              (responseBody["rates"][toCurrency]))
          .toString();
    });
    print(result);
    return "Success";
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: fromTextController,
              style: TextStyle(fontSize: 20.0, color: Colors.black45),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            trailing: _buildDropDownButton(fromCurrency),
          ),
          IconButton(
            icon: Icon(Icons.arrow_drop_down_circle),
            onPressed: _doConversion,
          ),
          ListTile(
            title: Chip(
              label: result != null
                  ? Text(
                      result,
                      style: Theme.of(context).textTheme.headline5,
                    )
                  : Text("                 "),
            ),
            trailing: _buildDropDownButton(toCurrency),
          ),
        ],
      ),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currency
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value),
                  ],
                ),
              ))
          .toList(),
      onChanged: (String value) {
        if (currencyCategory == fromCurrency) {
          _onFromChanged(value);
        } else {
          _onToChanged(value);
        }
      },
    );
  }
}
