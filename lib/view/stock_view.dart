import 'package:desafioapp/model/stock.dart';
import 'package:desafioapp/model/symbols.dart';
import 'package:desafioapp/widgets/chart_widget.dart';
import 'package:desafioapp/widgets/stock_datatable.dart';
import 'package:flutter/material.dart';

class StockView extends StatefulWidget {
  const StockView({super.key, this.symbol});

  final Symbol? symbol;
  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  late Future<Stock?> data;
  bool hasload = false;

  @override
  void initState() {
    super.initState();
    // data = Stock.getMock();
    data = Stock.get(widget.symbol?.symbol ?? "");
  }

  @override
  void didUpdateWidget(covariant StockView oldWidget) {
    super.didUpdateWidget(oldWidget);
    data = clearData();
    // data = Stock.getMock();
    data = Stock.get(widget.symbol?.symbol ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stock?>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(
                child: Text(
              "Dados nao carregados para o item escolhido.\n${widget.symbol?.symbol ?? ""}",
              style: const TextStyle(color: Colors.white),
            ));
          }

          return Column(
            children: [
              SizedBox(height: 200, child: ChartWidget(data: snapshot.data!)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.symbol!.name ?? "-",
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  height: MediaQuery.of(context).size.height - 340,
                  width: double.infinity,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: stockDataTable(context, snapshot.data!)))
            ],
          );
        });
  }

  Future<Stock?> clearData() async {
    return null;
  }
}
