import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card_challenge_demo/game/game.dart';
import 'package:flip_card_challenge_demo/model/score_record.dart';
import 'package:flip_card_challenge_demo/test.dart';
import 'package:flutter/material.dart';
import 'package:flip_card_challenge_demo/route/route.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class WelcomePage extends StatefulWidget {

    static Route<dynamic> route() {
        return SimpleRoute(
            name: '/',
            title: 'Card Mathcing Demo',
            builder: (_) => WelcomePage(),
        );
    }
    @override
    _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
    

    @override
    void initState() {
        super.initState();
    }

    @override
    void dispose() {
        super.dispose();
    }

    Stream<List<ScoreRecord>> get scoreList {
        return Firestore.instance.collection('scores')
            .orderBy('completeTime')
            .snapshots().map(
                (QuerySnapshot scores) => scores.documents.map(
                    (DocumentSnapshot doc) => ScoreRecord.fromJson(doc.data)
                ).toList()
        );
    }

    Widget scoreBoard() {
        return StreamBuilder<List<ScoreRecord>>(
            stream: scoreList,
            builder: (BuildContext context, AsyncSnapshot<List<ScoreRecord>> snapshot) {
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                final List<ScoreRecord> allScores = snapshot.data;
                return ListView.builder(
                    itemCount: allScores.length,
                    itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            title: Text(
                                StopWatchTimer.getDisplayTime(allScores[index].completeTime),
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    decoration: TextDecoration.none
                                ),
                                textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                                allScores[index].name,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.none
                                ),
                                textAlign: TextAlign.center,
                            ),
                        );
                    }
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Flexible(
                                flex: 2,
                                child: Image.asset(
                                    'welcome-page-question-mark-card.png',
                                )
                            ),
                            Flexible(
                                flex: 3,
                                child: Column(
                                    children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                                'Flip to dismiss all the cards as fast as you can',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.red,
                                                    decoration: TextDecoration.none
                                                ),
                                                textAlign: TextAlign.center,
                                            ),
                                        ),
                                        RaisedButton(
                                            onPressed: () {
                                                Navigator.of(context).pushReplacement(GamePage.route());
                                            },
                                            child: Text(
                                                'Start!',
                                                style: TextStyle(fontSize: 20),
                                            )
                                        ),
                                        RaisedButton(
                                            onPressed: () {
                                                Navigator.of(context).pushReplacement(TestPage.route());
                                            },
                                            child: Text(
                                                'TEST TEST',
                                                style: TextStyle(fontSize: 20),
                                            )
                                        ),
                                        Expanded(
                                            child: scoreBoard()
                                        )
                                    ],
                                )
                            ),
                        ],
                    );
                },
            )
        );
    }
}