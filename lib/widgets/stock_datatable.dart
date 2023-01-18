import 'package:desafioapp/model/stock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget stockDataTable(BuildContext context, Stock stock) {
  var listRows = <DataRow>[];
  double lastValue = 0;
  double initialValue = stock.quotesClose![0];
  for (var i = 0; i < stock.dates!.length; i++) {
    var value = stock.quotesClose![i];
    var d1 = (value * 100.00 / lastValue) - 100.00;
    var dX = (value * 100.00 / initialValue) - 100.00;

    var d1Color = Colors.white;
    if (d1 > 0.00) d1Color = Colors.green;
    if (d1 < 0.00) d1Color = Colors.red;

    var dXColor = Colors.white;
    if (dX > 0.00) dXColor = Colors.green;
    if (dX < 0.00) dXColor = Colors.red;

    var datarow = DataRow(cells: <DataCell>[
      DataCell(Text('${i + 1}')),
      DataCell(Text(DateFormat('dd/MM/yyyy').format(stock.dates![i]))),
      DataCell(Text('R\$ ${value.toStringAsFixed(2)}')),
      DataCell(Text(
        d1 == double.infinity || d1 == 0.0 ? "-" : d1.toStringAsFixed(2),
        style: TextStyle(color: d1Color),
      )),
      DataCell(Text(
        dX == double.infinity || dX == 0.0 ? "-" : dX.toStringAsFixed(2),
        style: TextStyle(color: dXColor),
      ))
    ]);
    listRows.add(datarow);
    lastValue = value;
  }

  var listColumns = "Dia,Data,Valor,D-1,%"
      .split(",")
      .map((e) => DataColumn(
            label: Text(e),
          ))
      .toList();

  return Container(
    color: Colors.black38,
    child: SizedBox(
        height: MediaQuery.of(context).size.height - 340,
        width: MediaQuery.of(context).size.width - 100,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: listColumns,
              rows: listRows,
              columnSpacing: 0,
            ))),
  );
}
