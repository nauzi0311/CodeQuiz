import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample2/Question.dart';
import 'package:sample2/ScoreDetailPage.dart';
import 'package:sample2/TopPage.dart';

class ListPageArgs<T> {
  T list;
  String title = "";
  ListPageArgs(this.list, this.title);
}

class ScoreListPage extends StatefulWidget {
  const ScoreListPage({Key? key}) : super(key: key);

  @override
  _ScoreListPageState createState() => _ScoreListPageState();
}

class _ScoreListPageState extends State<ScoreListPage> {
  @override
  Widget build(BuildContext context) {
    int count;
    final args = ModalRoute.of(context)!.settings.arguments as ListPageArgs;
    if (args.title == "C言語初級") {
      if (UserArgs.level >= ConfigArgs.Cbava.length) {
        count = ConfigArgs.Cbava[ConfigArgs.Cbava.length - 1];
      } else {
        count = ConfigArgs.Cbava[UserArgs.level];
      }
    } else if (args.title == "C言語中級") {
      if (UserArgs.level - ConfigArgs.openCm >= ConfigArgs.Cmava.length) {
        count = ConfigArgs.Cmava[ConfigArgs.Cmava.length - 1];
      } else {
        count = ConfigArgs.Cmava[UserArgs.level - ConfigArgs.openCm];
      }
    } else if (args.title == "C言語上級") {
      if (UserArgs.level - ConfigArgs.openCh >= ConfigArgs.Chava.length) {
        count = ConfigArgs.Chava[ConfigArgs.Chava.length - 1];
      } else {
        count = ConfigArgs.Chava[UserArgs.level - ConfigArgs.openCh];
      }
    } else {
      count = 7;
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: ListView(
        children: [
          for (int i = 0; i < count; i++) _Item(args.list[i]),
        ],
      ),
    ));
  }

  Widget _Item(Question q) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: new BoxDecoration(
            border:
                new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
        child: Row(
          children: [
            Container(
                child: Text(
              q.id.toString() + " " + q.title,
              style: GoogleFonts.openSans(
                  fontSize: 20,
                  color: Colors.black87,
                  decoration: TextDecoration.none),
            ))
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed('/detail', arguments: ScoreDetailPageArgs(q));
      },
    );
  }
}
