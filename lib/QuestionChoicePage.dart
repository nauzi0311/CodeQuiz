// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample2/AnswerPage.dart';
import 'package:sample2/Question.dart';
import 'package:sample2/ResultPage.dart';

import 'package:google_fonts/google_fonts.dart';

class QuestionChoicePageArgs {
  List<String> uans = [], ans = [], exp = [];
  List<Question> quest = [];
  QuestionChoicePageArgs(this.uans, this.ans, this.quest, this.exp);
}

class QuestionChoicePage extends StatefulWidget {
  const QuestionChoicePage({Key? key}) : super(key: key);

  @override
  _QuestionChoicePageState createState() => _QuestionChoicePageState();
}

class _QuestionChoicePageState extends State<QuestionChoicePage> {
  int listr = 20;
  bool cvisible = false;
  static int pcount = 0;
  static List<int> correct = [0, 0, 0, 0, 0, 0, 0];
  List<String> uans = [], ans = [], exp = [];
  List<Question> quest = [];
  String question =
      "#include <stdio.h>\nint main(){\n\t??? a = 3;\n\tprintf(\"%d\",a);\n}";
  String? q_upper, q_lowwer;
  List<String> choice = ["char", "int", "int*", "struct"];
  String answer = "int";
  String output = "3";
  static int maxSeconds = 30;
  int seconds = maxSeconds;
  late Timer _timer;
  TextStyle qstyle = GoogleFonts.openSans(fontSize: 20, color: Colors.black);

  @override
  void initState() {
    super.initState();
    seconds = maxSeconds;
    _timer = countTimer();
  }

  Timer countTimer() {
    return Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (seconds < 1) {
          timer.cancel();
          exp.add(quest[pcount].exp.toString());
          if (pcount == 0) {
            for (var i = 0; i < correct.length; i++) {
              correct[i] = 0;
            }
          }
          pcount++;
          ans.add(answer);
          uans.add("Time out");
          if (pcount >= 7) {
            List<int> ids = [];
            for (int i = 0; i < quest.length; i++) {
              ids.add(quest[i].id);
            }
            Navigator.of(context).pushNamed('/result',
                arguments: ResultPageArgs(uans, ans, quest, exp, correct));
            pcount = 0;
          } else {
            Navigator.of(context).pushReplacementNamed('/answer',
                arguments: AnswerPageArgs(
                    uans, ans, quest, pcount, null, exp, correct));
          }
        } else {
          setState(() {
            seconds = seconds - 1;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final GlobalKey _targetkey = GlobalKey();
    final args =
        ModalRoute.of(context)!.settings.arguments as QuestionChoicePageArgs;
    uans = args.uans;
    ans = args.ans;
    quest = args.quest;
    exp = args.exp;
    if (quest[pcount].question.isNotEmpty) {
      question = quest[pcount].question;
    } else {
      question = question;
    }
    if (quest[pcount].answer.isNotEmpty) {
      for (int i = 0; i < 4; i++) {
        choice[i] = quest[pcount].answer[i].toString();
      }
      answer = quest[pcount].answer[quest[pcount].answer[4] - 1];
    } else {
      choice = choice;
    }
    if (quest[pcount].output.isNotEmpty) {
      output = quest[pcount].output;
    } else {
      output = output;
    }
    question = question.replaceAll('\t', '\t\t\t');
    q_upper = question.split('???')[0];
    if (q_upper != question) {
      q_lowwer = question.split('???')[1];
    }
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Stack(children: [
                Container(
                  color: Colors.green[200],
                  child: Center(
                    child: Text(
                      seconds.toString(),
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                if (ResultPageArgs.test == 0)
                  Align(
                      alignment: Alignment(1.0, 0.5),
                      child: ElevatedButton(
                        onPressed: () {
                          _timer.cancel();
                          pcount = 0;

                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/menu', (_) => false);
                        },
                        child: Text("Home"),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(24),
                        ),
                      ))
              ]),
            ),
            Expanded(
              flex: 5,
              child: Container(
                  constraints: BoxConstraints.expand(),
                  color: Colors.yellow[50],
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize: 20),
                                      children: [
                                    TextSpan(
                                        text: "???",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: "に入る適切なものを選ぼう",
                                        style: TextStyle(color: Colors.black))
                                  ])),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Stack(children: [
                                            SingleChildScrollView(
                                              child: Align(
                                                  key: _targetkey,
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 0, 0, 0),
                                                    child: RichText(
                                                        text: TextSpan(
                                                            style: qstyle,
                                                            children: [
                                                          TextSpan(
                                                              text: q_upper),
                                                          if (q_lowwer != null)
                                                            TextSpan(
                                                                text: "???",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          if (q_lowwer != null)
                                                            TextSpan(
                                                                text: q_lowwer)
                                                        ])),
                                                  )),
                                            ),
                                          ]),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.blue.shade300,
                                                      width: 2)),
                                              child: Stack(
                                                children: [
                                                  SingleChildScrollView(
                                                    child: Text(
                                                      output,
                                                      style: output == "???"
                                                          ? GoogleFonts
                                                              .openSans(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)
                                                          : qstyle,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Text(
                                                      "OutPut",
                                                      style: qstyle,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment(1.0, 0.5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _timer.cancel();
                                            exp.add(
                                                quest[pcount].exp.toString());
                                            if (pcount == 0) {
                                              for (var i = 0;
                                                  i < correct.length;
                                                  i++) {
                                                correct[i] = 0;
                                              }
                                            }
                                            pcount++;
                                            uans.add("Skip");
                                            ans.add(answer);
                                            Navigator.of(context).pushNamed(
                                                '/answer',
                                                arguments: AnswerPageArgs(
                                                    uans,
                                                    ans,
                                                    quest,
                                                    pcount,
                                                    null,
                                                    exp,
                                                    correct));
                                            if (pcount >= 7) {
                                              pcount = 0;
                                            }
                                          },
                                          child: Text("Skip"),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(24),
                                          ),
                                        ))
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  )),
            ),
            Expanded(
              flex: 4,
              child: Container(
                  color: Colors.yellow[50],
                  padding: EdgeInsets.fromLTRB(
                      20, size.height * 0.01, 20, size.height * 0.01),
                  child: GridView.count(
                    mainAxisSpacing: 2,
                    crossAxisCount: 2,
                    childAspectRatio: size.height / 400,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text(
                            choice[0],
                            style: (choice[0].length < listr)
                                ? TextStyle(fontSize: 25)
                                : TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            _timer.cancel();
                            exp.add(quest[pcount].exp.toString());
                            if (pcount == 0) {
                              for (var i = 0; i < correct.length; i++) {
                                correct[i] = 0;
                              }
                            }
                            pcount++;
                            uans.add(choice[0]);
                            ans.add(answer);
                            if (answer == choice[0]) {
                              correct[pcount - 1] = 1;
                              if (pcount >= 7) {
                                List<int> ids = [];
                                for (int i = 0; i < quest.length; i++) {
                                  ids.add(quest[i].id);
                                }
                                Navigator.of(context).pushNamed('/result',
                                    arguments: ResultPageArgs(
                                        uans, ans, quest, exp, correct));
                                pcount = 0;
                              } else {
                                setState(() {
                                  cvisible = true;
                                });
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.of(context).pushNamed(
                                    '/questionchoice',
                                    arguments: QuestionChoicePageArgs(
                                        uans, ans, quest, exp));
                                setState(() {
                                  cvisible = false;
                                });
                              }
                            } else {
                              Navigator.of(context).pushNamed('/answer',
                                  arguments: AnswerPageArgs(uans, ans, quest,
                                      pcount, null, exp, correct));
                              if (pcount >= 7) {
                                pcount = 0;
                              }
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text(
                            choice[1],
                            style: (choice[1].length < listr)
                                ? TextStyle(fontSize: 25)
                                : TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            _timer.cancel();
                            exp.add(quest[pcount].exp.toString());
                            if (pcount == 0) {
                              for (var i = 0; i < correct.length; i++) {
                                correct[i] = 0;
                              }
                            }
                            pcount++;
                            uans.add(choice[1]);
                            ans.add(answer);
                            if (answer == choice[1]) {
                              correct[pcount - 1] = 1;
                              if (pcount >= 7) {
                                List<int> ids = [];
                                for (int i = 0; i < quest.length; i++) {
                                  ids.add(quest[i].id);
                                }
                                Navigator.of(context).pushNamed('/result',
                                    arguments: ResultPageArgs(
                                        uans, ans, quest, exp, correct));
                                pcount = 0;
                              } else {
                                setState(() {
                                  cvisible = true;
                                });
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.of(context).pushNamed(
                                    '/questionchoice',
                                    arguments: QuestionChoicePageArgs(
                                        uans, ans, quest, exp));
                                setState(() {
                                  cvisible = false;
                                });
                              }
                            } else {
                              Navigator.of(context).pushNamed('/answer',
                                  arguments: AnswerPageArgs(uans, ans, quest,
                                      pcount, null, exp, correct));
                              if (pcount >= 7) {
                                pcount = 0;
                              }
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text(
                            choice[2],
                            style: (choice[2].length < listr)
                                ? TextStyle(fontSize: 25)
                                : TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            _timer.cancel();
                            exp.add(quest[pcount].exp.toString());
                            if (pcount == 0) {
                              for (var i = 0; i < correct.length; i++) {
                                correct[i] = 0;
                              }
                            }
                            pcount++;
                            uans.add(choice[2]);
                            ans.add(answer);
                            if (answer == choice[2]) {
                              correct[pcount - 1] = 1;
                              if (pcount >= 7) {
                                List<int> ids = [];
                                for (int i = 0; i < quest.length; i++) {
                                  ids.add(quest[i].id);
                                }
                                Navigator.of(context).pushNamed('/result',
                                    arguments: ResultPageArgs(
                                        uans, ans, quest, exp, correct));
                                pcount = 0;
                              } else {
                                setState(() {
                                  cvisible = true;
                                });
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.of(context).pushNamed(
                                    '/questionchoice',
                                    arguments: QuestionChoicePageArgs(
                                        uans, ans, quest, exp));
                                setState(() {
                                  cvisible = false;
                                });
                              }
                            } else {
                              Navigator.of(context).pushNamed('/answer',
                                  arguments: AnswerPageArgs(uans, ans, quest,
                                      pcount, null, exp, correct));
                              if (pcount >= 7) {
                                pcount = 0;
                              }
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text(
                            choice[3],
                            style: (choice[3].length < listr)
                                ? TextStyle(fontSize: 25)
                                : TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            _timer.cancel();
                            exp.add(quest[pcount].exp.toString());
                            if (pcount == 0) {
                              for (var i = 0; i < correct.length; i++) {
                                correct[i] = 0;
                              }
                            }
                            pcount++;
                            uans.add(choice[3]);
                            ans.add(answer);
                            if (answer == choice[3]) {
                              correct[pcount - 1] = 1;
                              if (pcount >= 7) {
                                List<int> ids = [];
                                for (int i = 0; i < quest.length; i++) {
                                  ids.add(quest[i].id);
                                }
                                Navigator.of(context).pushNamed('/result',
                                    arguments: ResultPageArgs(
                                        uans, ans, quest, exp, correct));
                                pcount = 0;
                              } else {
                                setState(() {
                                  cvisible = true;
                                });
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.of(context).pushNamed(
                                    '/questionchoice',
                                    arguments: QuestionChoicePageArgs(
                                        uans, ans, quest, exp));
                                setState(() {
                                  cvisible = false;
                                });
                              }
                            } else {
                              Navigator.of(context).pushNamed('/answer',
                                  arguments: AnswerPageArgs(uans, ans, quest,
                                      pcount, null, exp, correct));
                              if (pcount >= 7) {
                                pcount = 0;
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
        if (cvisible)
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Center(
                child: Text(
                  "Correct!",
                  style: TextStyle(color: Colors.red, fontSize: 50),
                ),
              ),
            ),
          )
      ]),
    ));
  }
}
