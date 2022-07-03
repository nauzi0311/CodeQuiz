import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sample2/AnswerPage.dart';
import 'package:sample2/BadgeDetailPage.dart';
import 'package:sample2/BadgePage.dart';
import 'package:sample2/MenuPage.dart';
import 'package:sample2/QuestionChoicePage.dart';
import 'package:sample2/QuestionTypeHardPage.dart';
import 'package:sample2/QuestionTypePage.dart';
import 'package:sample2/ResultPage.dart';
import 'package:sample2/ScoreDetailPage.dart';
import 'package:sample2/ScoreListPage.dart';
import 'package:sample2/ScorePage.dart';
import 'package:sample2/SelectLangPage.dart';
import 'package:sample2/SelectLevelPage.dart';
import 'package:sample2/SignUpPage.dart';
import 'package:sample2/TopPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TopPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new TopPage(),
        '/signup': (BuildContext context) => new SignUpPage(),
        '/menu': (BuildContext context) => new MenuPage(),
        '/questionchoice': (BuildContext context) => new QuestionChoicePage(),
        '/questiontype': (BuildContext context) => new QuestionTypePage(),
        '/questionhard': (BuildContext context) => new QuestionTypeHardPage(),
        '/selectlevel': (BuildContext context) => new SelectLevelPage(),
        '/result': (BuildContext context) => new Resultpage(),
        '/score': (BuildContext context) => new ScorePage(),
        '/select': (BuildContext context) => new SelectLangPage(),
        '/answer': (BuildContext context) => new AnswerPage(),
        '/slist': (BuildContext context) => new ScoreListPage(),
        '/detail': (BuildContext context) => new ScoreDetailPage(),
        '/badge': (BuildContext context) => new BadgesPage(),
        '/badgedetail': (BuildContext context) => new BadgeDetailPage()
      },
    );
  }
}
