import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class Stock {
  List<double>? quotesClose;
  List<DateTime>? dates;

  Stock(this.quotesClose, this.dates);

  Stock.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json["chart"]["result"][0];
    Map<String, dynamic> indicators = data["indicators"]["quote"][0];

    dates = (List<int>.from(data["timestamp"] ?? []))
        .map((e) => DateTime.fromMillisecondsSinceEpoch(e * 1000))
        .toList();
    quotesClose = List<double>.from(indicators["close"] ?? []);
  }

  static Future<Stock?> get(String ticker) async {
    debugPrint("ticker: $ticker");

    final url = Uri.https(
      'query2.finance.yahoo.com',
      '/v8/finance/chart/$ticker',
      {'q': '{http}'},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      return Stock.fromJson(jsonResponse);
    }

    return null;
  }

  static Future<Stock> getMock() async {
    dynamic data = json.decode(await getJson());
    return Stock.fromJson(data);
  }

  static Future<String> getJson() {
    return rootBundle.loadString('lib/mock/stock.json');
  }
}
