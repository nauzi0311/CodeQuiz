import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sample2/Question.dart';
import 'package:sample2/QuestionChoicePage.dart';
import 'package:sample2/QuestionTypeHardPage.dart';
import 'package:sample2/ResultPage.dart';

import 'QuestionTypePage.dart';

class AnswerPageArgs {
  List<String> uans = [], ans = [], exp = [];
  List<Question> quest = [];
  String? error = null;
  int pcount;
  List<int> correct = [];
  AnswerPageArgs(this.uans, this.ans, this.quest, this.pcount, this.error,
      this.exp, this.correct);
}

class AnswerPage extends StatefulWidget {
  const AnswerPage({Key? key}) : super(key: key);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  int pcount = 0;
  List<String> uans = [], ans = [], exp = [];
  List<Question> quest = [];
  String question =
      "#include <stdio.h>\nint main(){\n\t??? a = 3;\n\tprintf(\"%d\",a);\n}";
  late String question_upper;
  late String question_lowwer;
  String answer = "int";
  String output = "3";
  String title = "Answer";
  String? error = null;
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
    final Size size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as AnswerPageArgs;
    uans = args.uans;
    ans = args.ans;
    quest = args.quest;
    pcount = args.pcount;
    error = args.error;
    exp = args.exp;
    if (quest[pcount - 1].question.isNotEmpty) {
      question = quest[pcount - 1].question;
    } else {
      question = question;
    }
    if (quest[pcount - 1].output.isNotEmpty) {
      output = quest[pcount - 1].output;
    } else {
      output = output;
    }
    if (quest[pcount - 1].title.isNotEmpty) {
      title = quest[pcount - 1].title;
    } else {
      title = title;
    }
    if (quest[pcount - 1].answer.isNotEmpty) {
      if (quest[pcount - 1].answer is List<dynamic>) {
        for (int i = 0; i < 4; i++) {
          choice[i] = quest[pcount - 1].answer[i].toString();
        }
        answer = quest[pcount - 1].answer[quest[pcount - 1].answer[4] - 1];
      } else if (quest[pcount - 1].answer is String) {
        answer = quest[pcount - 1].answer;
      }
    } else {
      choice = choice;
    }
    question = question.replaceAll('\t', '\t\t\t');
    List qsplit = question.split(RegExp(r'\?\?\?(l[1-9][0-9]*)?'));
    question_upper = qsplit[0];
    if (qsplit.length == 2) {
      question_lowwer = qsplit[1];
      question = question.replaceAll("???", answer);
    } else {
      output = output.replaceAll("???", answer);
    }
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green[200],
              child: Center(
                child: Text(
                  title,
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
                      TextSpan(text: question_upper),
                      if (quest[pcount - 1].output != "???")
                        TextSpan(
                            text: answer + " ",
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold)),
                      if (quest[pcount - 1].output != "???")
                        TextSpan(text: question_lowwer)
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
                      output,
                      style: quest[pcount - 1].output != "???"
                          ? qstyle
                          : GoogleFonts.openSans(
                              fontSize: 20,
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold),
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
          if (error != null)
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    border:
                        Border.all(color: Colors.yellow.shade700, width: 2)),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Text(
                        error!,
                        style: quest[pcount - 1].output != "???"
                            ? qstyle
                            : GoogleFonts.openSans(
                                fontSize: 20,
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "ERROR",
                        style: qstyle,
                      ),
                    )
                  ],
                ),
              ),
            )),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.yellow[50],
              child: GridView.count(
                  mainAxisSpacing: 2,
                  crossAxisCount: 1,
                  childAspectRatio: size.height / 400,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          20, size.height * 0.02, 20, size.height * 0.15),
                      child: ElevatedButton(
                        child: Text(
                          "Next",
                          style: TextStyle(fontSize: 25),
                        ),
                        onPressed: () async {
                          print(args.correct);
                          if (pcount >= 7) {
                            Navigator.of(context).pushNamed('/result',
                                arguments: ResultPageArgs(
                                    uans, ans, quest, exp, args.correct));
                          } else {
                            if (((quest[pcount - 1].id) ~/ 1000) == 1) {
                              Navigator.of(context).pushReplacementNamed(
                                  '/questionchoice',
                                  arguments: QuestionChoicePageArgs(
                                      uans, ans, quest, exp));
                            } else if ((quest[pcount - 1].id) ~/ 1000 == 2) {
                              Navigator.of(context).pushReplacementNamed(
                                  '/questiontype',
                                  arguments: QuestionTypePageArgs(
                                      uans, ans, quest, exp));
                            } else if ((quest[pcount - 1].id) ~/ 1000 == 3) {
                              Navigator.of(context).pushReplacementNamed(
                                  '/questionhard',
                                  arguments: QuestionTypeHardPageArgs(
                                      uans, ans, quest, exp));
                            } else {
                              print((quest[pcount - 1].id) ~/ 1000);
                            }
                          }
                        },
                      ),
                    )
                  ]),
            ),
          )
        ],
      ),
    ));
  }
}
