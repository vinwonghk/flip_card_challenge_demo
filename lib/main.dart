import 'package:flip_card_challenge_demo/game/game.dart';
import 'package:flip_card_challenge_demo/test.dart';
import 'package:flutter/material.dart';
import 'package:flip_card_challenge_demo/welcome.dart';

void main() {
    runApp(CardMatchingApp());
}

class CardMatchingApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            onGenerateRoute: (settings) {
            switch(settings.name) {
                case "/": return WelcomePage.route();
                case "/game": return GamePage.route();
                case "/test": return TestPage.route();
                default: return WelcomePage.route();
            }
            },
            initialRoute: "/",
        );
    }
}