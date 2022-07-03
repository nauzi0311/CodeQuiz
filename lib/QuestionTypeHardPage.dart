import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample2/AnswerPage.dart';
import 'package:sample2/OverlayLoadingMolecules.dart';
import 'package:sample2/Question.dart';
import 'package:sample2/ResultPage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'DeviceInfo.dart';
import 'TopPage.dart';

class QuestionTypeHardPageArgs {
  List<String> uans = [], ans = [], exp = [];
  List<Question> quest = [];
  QuestionTypeHardPageArgs(this.uans, this.ans, this.quest, this.exp);
}

class QuestionTypeHardPage extends StatefulWidget {
  const QuestionTypeHardPage({Key? key}) : super(key: key);

  @override
  _QuestionTypeHardPageState createState() => _QuestionTypeHardPageState();
}

class _QuestionTypeHardPageState extends State<QuestionTypeHardPage> {
  bool visible = false;
  bool cvisible = false;
  static int pcount = 0;
  static List<int> correct = [0, 0, 0, 0, 0, 0, 0];
  List<String> uans = [], ans = [], exp = [];
  List<Question> quest = [];
  String answer = "int";
  String question =
      "#include <stdio.h>\nint main(){\n\t??? a = 3;\n\tprintf(\"%d\",a);\n}";
  String? q_upper, q_lowwer;
  String output = "3";
  static int maxSeconds = 180;
  int seconds = maxSeconds;
  int limit = 5;
  int maxlength = 0;
  late Timer _timer;
  TextStyle qstyle = GoogleFonts.openSans(fontSize: 20, color: Colors.black);
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    seconds = maxSeconds;
    _timer = countTimer();
  }

  Timer countTimer() {
    return Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
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
            double point = UserArgs.current_point;
            double maxpoint = UserArgs.maxpoint;
            // for (int i = 0; i < quest.length; i++) {
            //   ids.add(quest[i].id);
            //   if (correct[i] == 1) {
            //     correct.add(quest[i].id);
            //     point = point + quest[i].exp;
            //     if (point > maxpoint) {
            //       //level up
            //       point = point - maxpoint;
            //       UserArgs.level = UserArgs.level + 1;
            //       Map<String, dynamic> llist = jsonDecode(
            //           await rootBundle.loadString('assets/json/level.json'));
            //       UserArgs.maxpoint =
            //           llist[UserArgs.level.toString()].toDouble();
            //       maxpoint = UserArgs.maxpoint;
            //     }
            //   }
            // }
            // UserArgs.current_point = point;
            // late String _content;
            // String url = ConfigArgs.url + "user";
            // Map<String, String> headers = {'content-type': 'application/json'};
            // var id;
            // getDeviceUniqueId().then((value) => id = value);
            // var jsonstring = {
            //   "device": id,
            //   "level": UserArgs.level,
            //   "point": UserArgs.current_point
            // };
            // String body = json.encode(jsonstring);
            // http.Response resp =
            //     await http.post(Uri.parse(url), headers: headers, body: body);
            // if (resp.statusCode != 200) {
            //   setState(() {
            //     int statusCode = resp.statusCode;
            //     _content = "Failed to post $statusCode";
            //   });
            //   return;
            // }
            // setState(() {
            //   _content = resp.body;
            // });
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

  Timer noconnect() {
    return Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (limit < 1) {
          timer.cancel();
          exp.add(quest[pcount].exp.toString());
          if (pcount == 0) {
            for (var i = 0; i < correct.length; i++) {
              correct[i] = 0;
            }
          }
          pcount++;
          ans.add(answer);
          uans.add(_controller.text);
          if (_controller.text == answer) {
            if (pcount >= 7) {
              List<int> ids = [];
              for (int i = 0; i < quest.length; i++) {
                ids.add(quest[i].id);
              }
              Navigator.of(context).pushNamed('/result',
                  arguments: ResultPageArgs(uans, ans, quest, exp, correct));
              pcount = 0;
            } else {
              Navigator.of(context).pushNamed('/questionhard',
                  arguments: QuestionTypeHardPageArgs(uans, ans, quest, exp));
            }
          } else {
            Navigator.of(context).pushNamed('/answer',
                arguments: AnswerPageArgs(
                    uans, ans, quest, pcount, null, exp, correct));
            if (pcount >= 7) pcount = 0;
          }
        } else {
          setState(() {
            limit = limit - 1;
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
    final args =
        ModalRoute.of(context)!.settings.arguments as QuestionTypeHardPageArgs;
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
      answer = quest[pcount].answer;
    } else {
      answer = answer;
    }
    if (quest[pcount].output.isNotEmpty) {
      output = quest[pcount].output;
    } else {
      output = output;
    }
    if (quest[pcount].restrict != 0) {
      maxlength = quest[pcount].restrict!;
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
              flex: 6,
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
                                        text: "に入る適切なものを入力しよう",
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
                                          child: SingleChildScrollView(
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                                  child: RichText(
                                                      text: TextSpan(
                                                          style: qstyle,
                                                          children: [
                                                        TextSpan(text: q_upper),
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
                                            if (pcount >= 7) pcount = 0;
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
              flex: 3,
              child: Container(
                  color: Colors.yellow[50],
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: maxlength,
                        enabled: true,
                        controller: _controller,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Type here"),
                      ),
                      ElevatedButton(
                        child: Text("Answer", style: TextStyle(fontSize: 25)),
                        onPressed: () async {
                          setState(() {
                            visible = true;
                          });
                          late Timer _noconnect;
                          late String _content;
                          _timer.cancel();
                          uans.add(_controller.text);
                          ans.add(answer);
                          exp.add(quest[pcount].exp.toString());
                          String url = ConfigArgs.url + "quest/check";
                          Map<String, String> headers = {
                            'content-type': 'application/json'
                          };
                          var jsonstring = {
                            "id": quest[pcount].id,
                            "ans": _controller.text
                          };
                          String body = jsonEncode(jsonstring);
                          if (RegExp(r'system').hasMatch(_controller.text)) {
                            _content = 'Your answer contains "system"';
                          } else if (RegExp(r'fork')
                              .hasMatch(_controller.text)) {
                            _content = 'Your answer contains "fork"';
                          } else if (RegExp(r'thread')
                              .hasMatch(_controller.text)) {
                            _content = 'Your answer contains "thread"';
                          } else {
                            http.Response resp = await http.post(Uri.parse(url),
                                headers: headers, body: body);
                            _noconnect = noconnect();
                            if (resp.statusCode != 200) {
                              setState(() {
                                int statusCode = resp.statusCode;
                                _content = "Failed to post $statusCode";
                                _noconnect.cancel();
                              });
                              return;
                            }
                            setState(() {
                              _content = resp.body;
                              _noconnect.cancel();
                              visible = false;
                            });
                          }
                          if (pcount == 0) {
                            for (var i = 0; i < correct.length; i++) {
                              correct[i] = 0;
                            }
                          }
                          pcount++;
                          if (_content == "AC") {
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
                              Navigator.of(context).pushNamed('/questionhard',
                                  arguments: QuestionTypeHardPageArgs(
                                      uans, ans, quest, exp));
                              setState(() {
                                cvisible = false;
                              });
                            }
                          } else {
                            Navigator.of(context).pushNamed('/answer',
                                arguments: AnswerPageArgs(uans, ans, quest,
                                    pcount, _content, exp, correct));
                            if (pcount >= 7) pcount = 0;
                          }
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
        OverlayLoadingMolecules(
            visible: visible, width: MediaQuery.of(context).size.width),
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
