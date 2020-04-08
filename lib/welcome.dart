import 'package:flip_card_challenge_demo/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flip_card_challenge_demo/route/route.dart';

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
        // WidgetsBinding.instance.addObserver(this);
    }

    @override
    void dispose() {
        // WidgetsBinding.instance.removeObserver(this);
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return LayoutBuilder(
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
                                    )
                                ],
                            )
                        )
                    ],
                );
            },
        );
    }
}