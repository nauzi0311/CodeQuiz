import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample2/Question.dart';

class ScoreDetailPageArgs {
  Question q;
  ScoreDetailPageArgs(this.q);
}

class ScoreDetailPage extends StatefulWidget {
  const ScoreDetailPage({Key? key}) : super(key: key);

  @override
  _ScoreDetailPageState createState() => _ScoreDetailPageState();
}

class _ScoreDetailPageState extends State<ScoreDetailPage> {
  late Question quest;
  String question =
      "#include <stdio.h>\nint main(){\n\t??? a = 3;\n\tprintf(\"%d\",a);\n}";
  String answer = "int";
  String output = "3";
  String title = "Answer";
  String? error;
  List<String> choice = ["char", "int", "int*", "struct"];
  TextStyle qstyle = GoogleFonts.openSans(fontSize: 20, color: Colors.black);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ScoreDetailPageArgs;
    quest = args.q;
    return SafeArea(
        child: Stack(children: [
      Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.green[200],
                child: Center(
                  child: Text(
                    quest.title,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                constraints: BoxConstraints.expand(),
                color: Colors.yellow[50],
                child: Container(
                  child: SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: RichText(
                      text: TextSpan(style: qstyle, children: [
                        TextSpan(text: quest.question),
                      ]),
                    ),
                  )),
                ),
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    border: Border.all(color: Colors.blue.shade300, width: 2)),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Text(
                        quest.output,
                        style: qstyle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "OutPut",
                        style: qstyle,
                      ),
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
      Align(
          alignment: Alignment(1.0, 0.5),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Back"),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(24),
            ),
          ))
    ]));
  }
}
