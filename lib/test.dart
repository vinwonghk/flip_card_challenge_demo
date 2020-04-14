import 'package:flutter/material.dart';
import 'package:flip_card_challenge_demo/route/route.dart';

class TestPage extends StatefulWidget {

    static Route<dynamic> route() {
        return SimpleRoute(
            name: '/test',
            title: 'Test Test',
            builder: (_) => TestPage(),
        );
    }
    @override
    _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
    

    @override
    void initState() {
        super.initState();
    }

    @override
    void dispose() {
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                    return ListView(
                        children: <Widget>[
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                            Image.asset(
                                'welcome-page-question-mark-card.png',
                            ),
                        ],
                    );
                },
            )
        );
    }
}