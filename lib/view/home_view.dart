import 'package:desafioapp/model/symbols.dart';
import 'package:desafioapp/view/stock_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.name});

  final String name;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController textEditingController = TextEditingController();
  List<Symbol> autoCompleteData = [];
  List<Widget> appBarActions = [];
  bool isSearching = false;
  Symbol? selectedSymbol;
  String searchTerm = "";
  Widget content = Container();

  _HomeViewState() {
    textEditingController.addListener(() {
      if (textEditingController.text.isEmpty) {
        setState(() {
          isSearching = false;
          searchTerm = "";
        });
      } else {
        setState(() {
          isSearching = true;
          searchTerm = textEditingController.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateActions();
    loadSymbols();
    content = Container();
  }

  void loadSymbols() {
    Symbol.getMock().then((value) => {autoCompleteData = value});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build: ${selectedSymbol?.symbol ?? ""}");
    return Scaffold(
        key: key,
        appBar: buildBar(context),
        body: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xff232d37),
            ),
            child: Stack(
              children: <Widget>[
                if (selectedSymbol == null)
                  Center(
                      child: Text(
                    "Symbol: ${selectedSymbol?.symbol ?? "vazio"}",
                    style: const TextStyle(color: Colors.white),
                  ))
                else
                  StockView(symbol: selectedSymbol),
                displayAutoComplete(),
              ],
            )));
  }

  PreferredSizeWidget? buildBar(BuildContext context) {
    Widget appTitle = isSearching
        ? TextField(
            autofocus: true,
            controller: textEditingController,
            decoration: const InputDecoration(
              hintText: "Busque o ativo ... ",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          )
        : Text(
            selectedSymbol?.symbol ?? widget.name,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Colors.white),
          );

    return AppBar(
      backgroundColor: Colors.black,
      title: appTitle,
      actions: appBarActions,
    );
  }

  Widget displayAutoComplete() {
    return Align(
        alignment: Alignment.topCenter,
        child: isSearching ? autoCompleteList() : Container());
  }

  Widget autoCompleteList() {
    List<Symbol> results = autoCompleteListLoad();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, int index) {
          return buildAutoCompleteTile(results.elementAt(index));
        },
      ),
    );
  }

  List<Symbol> autoCompleteListLoad() {
    List<Symbol> result = [];
    List<Symbol> containsList = [];

    if (searchTerm.isEmpty) {
      result = autoCompleteData.toList();
    } else {
      for (var symbol in autoCompleteData) {
        if (symbol.name!.toLowerCase().startsWith(searchTerm.toLowerCase()) ||
            symbol.symbol!.toLowerCase().startsWith(searchTerm.toLowerCase())) {
          result.add(symbol);
        } else if (symbol.name!
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            symbol.symbol!.toLowerCase().contains(searchTerm.toLowerCase())) {
          containsList.add(symbol);
        }
      }
    }

    result.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
    result.addAll(containsList);
    return result;
  }

  Widget buildAutoCompleteTile(Symbol symbol) {
    return ListTile(
        onTap: () {
          debugPrint("buildAutoCompleteTile.ListTile.onTap: ${symbol.symbol}");
          setState(() {
            selectedSymbol = symbol;
            isSearching = false;
            updateActions();
          });
        },
        title: Row(
          children: [
            SizedBox(
              width: 55,
              child: Text(symbol.symbol!,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold)),
            ),
            const VerticalDivider(),
            Expanded(
              child: Text(
                symbol.name!,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white70,
                ),
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ));
  }

  void startSearch() {
    setState(() {
      isSearching = true;
      updateActions();
    });
  }

  void endSearch({Symbol? symbol}) {
    setState(() {
      textEditingController.clear();
      isSearching = false;
      selectedSymbol = symbol;
      updateActions();
      debugPrint("endSearch: ${symbol?.symbol ?? ""}");
    });
  }

  void updateActions() {
    if (isSearching) {
      appBarActions = <Widget>[
        IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              endSearch();
            })
      ];
    } else {
      appBarActions = <Widget>[
        IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              startSearch();
            })
      ];
    }
  }
}
