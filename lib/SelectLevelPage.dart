import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample2/OverlayLoadingMolecules.dart';
import 'package:sample2/Question.dart';
import 'package:sample2/QuestionChoicePage.dart';
import 'package:sample2/QuestionTypeHardPage.dart';
import 'package:sample2/QuestionTypePage.dart';
import 'package:sample2/ResultPage.dart';
import 'package:sample2/TopPage.dart';
import 'package:http/http.dart' as http;

import 'DeviceInfo.dart';

class SelectLevelPage extends StatefulWidget {
  SelectLevelPage({Key? key}) : super(key: key);

  @override
  _SelectLevelPageState createState() => _SelectLevelPageState();
}

class _SelectLevelPageState extends State<SelectLevelPage> {
  late List<Question> _Cqlist = [];
  bool select = true;
  bool visible = false;
  int level = UserArgs.level;
  double point = UserArgs.current_point;
  double maxpoint = UserArgs.maxpoint;
  final TextEditingController _ucontroller = TextEditingController();
  final TextEditingController _pcontroller = TextEditingController();
  var id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceUniqueId().then((value) => id = value);
  }

  @override
  Widget build(BuildContext context) {
    List<String> qnum = [];
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Align(
          alignment: Alignment(0.0, -0.2),
          child: Center(
            child: Container(
              height: 400,
              width: 350,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "C言語に関しての自分のレベルを選択してください。",
                      style: GoogleFonts.openSans(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          ResultPageArgs.test = 1;
                          setState(() {
                            visible = true;
                          });
                          for (int i = 0; i < 7; i++) {
                            qnum.add(
                                (Random().nextInt(ConfigArgs.Cbava.last) + 1001)
                                    .toString());
                            qnum = qnum.toSet().toList();
                            if (qnum.length <= i) {
                              i--;
                              continue;
                            }
                          }
                          await _jsonFileLoad(qnum).then((value) {
                            setState(() {
                              _Cqlist = value;
                              assert(_Cqlist.isEmpty == false);
                            });
                          });
                          setState(() {
                            visible = false;
                          });
                          Navigator.of(context).pushNamed('/questionchoice',
                              arguments:
                                  QuestionChoicePageArgs([], [], _Cqlist, []));
                        },
                        child: Text("初心者")),
                    ElevatedButton(
                        onPressed: () async {
                          ResultPageArgs.test = 2;
                          late String _content;
                          setState(() {
                            visible = true;
                          });
                          for (int i = 0; i < 7; i++) {
                            qnum.add(
                                (Random().nextInt(ConfigArgs.Cmava.last) + 2001)
                                    .toString());
                            qnum = qnum.toSet().toList();
                            if (qnum.length <= i) {
                              i--;
                              continue;
                            }
                          }

                          String url = ConfigArgs.url + "quest/flutter";
                          Map<String, String> headers = {
                            'content-type': 'application/json'
                          };
                          for (int i = 0; i < qnum.length; i++) {
                            var jsonstring = {"q": int.parse(qnum[i])};
                            String body = json.encode(jsonstring);
                            http.Response resp = await http.post(Uri.parse(url),
                                headers: headers, body: body);
                            if (resp.statusCode != 200) {
                              setState(() {
                                int statusCode = resp.statusCode;
                                _content = "Failed to post $statusCode";
                              });
                              return;
                            }
                            setState(() {
                              _content = resp.body;
                            });
                            _Cqlist = _jsonaddlist(_Cqlist, _content);
                          }
                          setState(() {
                            visible = false;
                          });
                          Navigator.of(context).pushNamed('/questiontype',
                              arguments:
                                  QuestionTypePageArgs([], [], _Cqlist, []));
                        },
                        child: Text("中級者")),
                    ElevatedButton(
                        onPressed: () async {
                          ResultPageArgs.test = 3;
                          late String _content;
                          setState(() {
                            visible = true;
                          });
                          for (int i = 0; i < 7; i++) {
                            qnum.add(
                                (Random().nextInt(ConfigArgs.Chava.last) + 3001)
                                    .toString());
                            qnum = qnum.toSet().toList();
                            if (qnum.length <= i) {
                              i--;
                              continue;
                            }
                          }
                          String url = ConfigArgs.url + "quest/flutter";
                          Map<String, String> headers = {
                            'content-type': 'application/json'
                          };
                          for (int i = 0; i < qnum.length; i++) {
                            var jsonstring = {"q": int.parse(qnum[i])};
                            String body = json.encode(jsonstring);
                            http.Response resp = await http.post(Uri.parse(url),
                                headers: headers, body: body);
                            if (resp.statusCode != 200) {
                              setState(() {
                                int statusCode = resp.statusCode;
                                _content = "Failed to post $statusCode";
                              });
                              return;
                            }
                            setState(() {
                              _content = resp.body;
                            });
                            _Cqlist = _jsonaddlist(_Cqlist, _content);
                          }
                          setState(() {
                            visible = false;
                          });
                          Navigator.of(context).pushNamed('/questionhard',
                              arguments: QuestionTypeHardPageArgs(
                                  [], [], _Cqlist, []));
                        },
                        child: Text("上級者")),
                  ],
                ),
              ),
            ),
          ),
        ),
        OverlayLoadingMolecules(
            visible: visible, width: MediaQuery.of(context).size.width)
      ]),
    ));
  }

  List<Question> _jsonaddlist(List<Question> qlist, String item) {
    Question temp;
    Map<String, dynamic> map = jsonDecode(item);
    temp = Question(map['id'], map['title'], map['question'], map['output'],
        map['answer'], map['exp'], map['point'],
        restrict: map['restrict']);
    qlist.add(temp);
    return qlist;
  }

  Future<dynamic> _jsonFileLoad(List<String> file) async {
    String jsonString;
    List<Question> list = [];
    for (int i = 0; i < file.length; i++) {
      String path = 'assets/json/' + file[i] + '.json';
      Question temp;
      try {
        jsonString = await rootBundle.loadString(path);
      } on FlutterError {
        print('Faild to open $path');
        exit(0);
      }
      temp = Question(
          json.decode(jsonString)['id'],
          json.decode(jsonString)['title'],
          json.decode(jsonString)['question'],
          json.decode(jsonString)['output'],
          json.decode(jsonString)['answer'],
          json.decode(jsonString)['exp'],
          json.decode(jsonString)['point']);
      list.add(temp);
    }
    return list;
  }
}

class Case extends StatelessWidget {
  const Case({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.07, -0.99),
      child: Container(
        color: Colors.amber,
        child: CustomPaint(
          painter: CasePainter(size.width),
        ),
      ),
    );
  }
}

class Gauge extends StatelessWidget {
  const Gauge({
    Key? key,
    required this.size,
    required this.point,
    required this.maxpoint,
  }) : super(key: key);

  final Size size;
  final double point;
  final double maxpoint;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.07, -0.99),
      child: Container(
        color: Colors.amber,
        child: CustomPaint(
          painter: GaugePainter(size.width, point / maxpoint),
        ),
      ),
    );
  }
}

class Level extends StatelessWidget {
  const Level({
    Key? key,
    required this.level,
  }) : super(key: key);

  final int level;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.07, -0.99),
      child: Text(
        "Lv" + level.toString(),
        style: GoogleFonts.openSans(
            fontSize: 16,
            color: Colors.green.shade600,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none),
      ),
    );
  }
}

class Point extends StatelessWidget {
  const Point({
    Key? key,
    required this.point,
    required this.maxpoint,
  }) : super(key: key);

  final double point;
  final double maxpoint;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.925, -0.95),
      child: Text(
        point.round().toString() + "/" + maxpoint.round().toString(),
        style: GoogleFonts.openSans(
            fontSize: 12,
            color: Colors.green.shade600,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none),
      ),
    );
  }
}

class CasePainter extends CustomPainter {
  double width;
  CasePainter(this.width);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 10;
    canvas.drawLine(Offset(30, 10), Offset(width / 2.75 + 30, 10), paint);
  }

  @override
  bool shouldRepaint(CasePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CasePainter oldDelegate) => false;
}

class GaugePainter extends CustomPainter {
  double width, rate;
  GaugePainter(this.width, this.rate);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade600
      ..strokeWidth = 10;
    canvas.drawLine(
        Offset(30, 10), Offset(width / 2.75 * rate + 30, 10), paint);
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(GaugePainter oldDelegate) => false;
}

Future<File> getFilePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return File(directory.path + '/' + fileName);
}
