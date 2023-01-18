import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class Symbol {
  String? symbol;
  String? name;
  String? longName;
  String? shortName;

  Symbol({this.symbol, this.longName, this.shortName});

  Symbol.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    longName = json['longName'];
    shortName = json['shortName'];
    name = longName ?? shortName ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['symbol'] = symbol;
    data['longName'] = longName;
    data['shortName'] = shortName;
    return data;
  }

  static Future<List<Symbol>> getMock() async {
    List<dynamic> data = json.decode(await getJson());
    return data.map((e) => Symbol.fromJson(e)).toList();
  }

  static Future<String> getJson() {
    return rootBundle.loadString('lib/mock/symbols.json');
  }
}
