
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card_challenge_demo/model/card.dart';
import 'package:flip_card_challenge_demo/route/route.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card_challenge_demo/welcome.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GamePage extends StatefulWidget {

    static Route<dynamic> route() {
        return SimpleRoute(
            name: '/game',
            title: 'Card Mathcing Start',
            builder: (_) => GamePage(),
        );
    }

    GamePage({this.cardsNumber = 16});
    
    final int cardsNumber;

    @override
    _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

    List<GameCard> cardList = <GameCard>[
        GameCard(cardNumber: 1, color: Colors.red),
        GameCard(cardNumber: 2, color: Colors.blue),
        GameCard(cardNumber: 3, color: Colors.orange),
        GameCard(cardNumber: 4, color: Colors.purple),
        GameCard(cardNumber: 5, color: Colors.cyan),
        GameCard(cardNumber: 6, color: Colors.black),
        GameCard(cardNumber: 7, color: Colors.yellow),
        GameCard(cardNumber: 8, color: Colors.green),
        GameCard(cardNumber: 9, color: Colors.orange),
        GameCard(cardNumber: 10, color: Colors.blue),
        GameCard(cardNumber: 11, color: Colors.black),
        GameCard(cardNumber: 12, color: Colors.yellow),
        GameCard(cardNumber: 13, color: Colors.cyan),
        GameCard(cardNumber: 14, color: Colors.red),
        GameCard(cardNumber: 15, color: Colors.green),
        GameCard(cardNumber: 16, color: Colors.purple),
    ];

    List<GlobalKey<FlipCardState>> cardKeyList;

    bool gameStarted = false;

    bool gameOver = false;

    String documentId;

    TextEditingController _textEditingController;

    final StopWatchTimer _stopWatchTimer = StopWatchTimer();
    
    @override
    void initState() {
        super.initState();
        // shuffle the cards
        _textEditingController = TextEditingController();
        cardList = shuffle(cardList);
        cardKeyList = List.generate(widget.cardsNumber, (index) => GlobalKey<FlipCardState>());
    }

    @override
    void dispose() async {
        super.dispose();
        await _stopWatchTimer.dispose();
    }

    double width(BuildContext context) {
        return MediaQuery.of(context).size.width;
    }

    double height(BuildContext context) {
        return MediaQuery.of(context).size.height;
    }

    Widget gameEngine(BuildContext context) {
        return width(context) >= 1000
            ? Row(
                children: <Widget>[
                    Flexible(
                        flex: 4,
                        child: gameBoard(),
                    ),
                    Expanded(
                        child: infoPanel(),
                    )
                ],
            )
            : Column(
                children: <Widget>[
                    Flexible(
                        flex: 4,
                        child: gameBoard(),
                    ),
                    Expanded(
                        child: infoPanel(),
                    )
                ],
            );
    }

    Widget gameBoard() {
        return Stack(
            children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: GridView.count(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(20),
                        crossAxisCount: 4,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: cardList.map((GameCard card) {
                            return GridTile(
                                child: FlipCard(
                                    key: cardKeyList[card.cardNumber - 1],
                                    front: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black)
                                        ),
                                        child: Center(
                                            child: Text(
                                                'Flip me!',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                    decoration: TextDecoration.none
                                                ),
                                                textAlign: TextAlign.center,
                                            )
                                        )
                                    ),
                                    back: Container(color: card.color),
                                    onFlip: () {
                                        if (!gameStarted) {
                                            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                            setState(() {
                                                gameStarted = true;
                                            });
                                        }
                                    },
                                    onFlipDone: (bool result) async {
                                        if (cardKeyList[card.cardNumber - 1].currentState.isFront) {
                                            setState(() {
                                                cardList.remove(card);
                                            });
                                        }
                                        if (cardList.isEmpty) {
                                            setState(() {
                                                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                                gameOver = true;
                                            });
                                            final String temp = await uploadRecord(_stopWatchTimer.rawTime.value);
                                            setState(() {
                                                documentId = temp;
                                            });
                                        }
                                    },
                                )
                            );
                        }).toList(),
                    )
                )
            ],
        );
    }

    Widget infoPanel() {
        return ListView(
            children: <Widget>[
                StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (BuildContext context, AsyncSnapshot<int> snap) {
                        final int value = snap.data;
                        final String displayTime = StopWatchTimer.getDisplayTime(value);
                        return Text(
                            displayTime,
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.none
                            ),
                        );
                    },
                ),
                if (gameOver)
                    Column(
                        children: <Widget>[
                            TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Type your Name',
                                ),
                            ),
                            RaisedButton(
                                onPressed: () async {
                                    await updateName(documentId, _textEditingController.text);
                                    Navigator.of(context).pushReplacement(WelcomePage.route());
                                },
                                child: Text('Submit', style: TextStyle(fontSize: 18)),
                            ),
                        ],
                    ),
                if (gameOver)
                    RaisedButton(
                        onPressed: () => Navigator.of(context).pushReplacement(GamePage.route()),
                        child: Text('Retry', style: TextStyle(fontSize: 18)),
                    ),
                if (gameOver)
                    RaisedButton(
                        onPressed: () => Navigator.of(context).pushReplacement(WelcomePage.route()),
                        child: Text('Back to Home', style: TextStyle(fontSize: 18)),
                    ),
            ],
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                        children: <Widget>[
                            gameEngine(context),
                        ],
                    );
                },
            )
        );
    }

    List shuffle(List items) {
        var random = new Random();

        // Go through all elements.
        for (var i = items.length - 1; i > 0; i--) {

            // Pick a pseudorandom number according to the list length
            var n = random.nextInt(i + 1);

            var temp = items[i];
            items[i] = items[n];
            items[n] = temp;
        }

        return items;
    }

    Future<String> uploadRecord(int completeTime) async {
        final DocumentReference doc = await Firestore.instance.collection('scores').add({
            'name': 'Unnamed Hero',
            'completeTime': completeTime,
            'dateCreated': FieldValue.serverTimestamp()
        });
        return doc.documentID;
    }

    Future<void> updateName(String documentId, String name) {
        Firestore.instance.collection('scores').document(documentId).updateData({
            'name': name,
        });
    }
}