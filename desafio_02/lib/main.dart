import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Memory Game"),
        ),
        body: Center(
          child: Card(
            child: ChangeNotifierProvider(
              create: (context) => MemoryGame(),
              child: Consumer<MemoryGame>(
                builder: (context, provider, child) => Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 13,
                        ),
                        itemCount: provider.items.length,
                        itemBuilder: (context, index) {
                          final card = provider.items[index];
                          final selectedCard = index == provider.indexFirst ||
                              index == provider.indexSecond ||
                              provider.selectedItems.contains(card);
                          return GestureDetector(
                            onTap: () {
                              provider.turn(card, index, context);
                            },
                            child: Card(
                              color: selectedCard
                                  ? Colors.green[200]
                                  : Colors.cyan,
                              child: Center(
                                child: selectedCard
                                    ? provider.selectedItems.contains(card)
                                        ? Text(card)
                                        : Text(index == provider.indexFirst
                                            ? provider.firstCard.toString()
                                            : provider.secondCard.toString())
                                    : Text(index.toString()),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Center(
                          child: Text(
                            "Tentativas: ${provider.attempts}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MemoryGame extends ChangeNotifier {
  List<String> items = [
    'A',
    'A',
    'B',
    'B',
    'C',
    'C',
    'D',
    'D',
    'E',
    'E',
    'F',
    'F'
  ];
  List<String> selectedItems = [];
  int attempts = 0;
  bool isGameComplete() {
    return selectedItems.length == items.length ~/ 2;
  }

  String? firstCard;
  String? secondCard;
  int? indexFirst;
  int? indexSecond;

  void turn(card, index, BuildContext context) {
    if (firstCard == null) {
      firstCard = card;
      indexFirst = index;
    } else if (secondCard == null) {
      secondCard = card;
      indexSecond = index;

      attempts++;

      if (firstCard == secondCard) {
        selectedItems.add(firstCard!);
      }

      Fluttertoast.showToast(
        msg: 'Aguarde um momento...',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );

      Future.delayed(const Duration(seconds: 2), () {
        firstCard = null;
        secondCard = null;
        indexFirst = null;
        indexSecond = null;
        notifyListeners();
      });
    }

    if (isGameComplete()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Parabéns!'),
            content: const Text('Você completou o jogo'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    notifyListeners();
  }
}
