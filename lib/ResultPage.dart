import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample2/OverlayLoadingMolecules.dart';
import 'package:sample2/Question.dart';
import 'package:sample2/SignUpPage.dart';
import 'package:sample2/TopPage.dart';

import 'DeviceInfo.dart';

class ResultPageArgs {
  static int test = 0;
  List<String> ans = [], uans = [], exp = [];
  List<Question> quest = [];
  List<int> correct = [0, 0, 0, 0, 0, 0, 0];
  ResultPageArgs(this.uans, this.ans, this.quest, this.exp, this.correct);
}

class Resultpage extends StatefulWidget {
  Resultpage({Key? key}) : super(key: key);

  @override
  _ResultpageState createState() => _ResultpageState();
}

class _ResultpageState extends State<Resultpage> {
  int i = 0;
  bool levelup = false;
  bool disposable = true;
  bool visible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (disposable) {
      i = 0;
      super.dispose();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as ResultPageArgs;
    if (i == 0) {
      print("didChange");
      int levelb = UserArgs.level;
      if (ResultPageArgs.test == 0) {
        caluculate_point(args.quest, args.correct);
      } else if (ResultPageArgs.test == 1) {
        UserArgs.level = 1;
      } else if (ResultPageArgs.test == 2) {
        UserArgs.level = 6;
      } else if (ResultPageArgs.test == 3) {
        UserArgs.level = 12;
      } else {}
      if (levelb != UserArgs.level) levelup = true;
      DateTime now = DateTime.now();
      DateFormat outputFormat = DateFormat('yyyy-MM-dd');
      String date = outputFormat.format(now);
      UserArgs.date.add(date);
      UserArgs.date = UserArgs.date.toSet().toList();
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as ResultPageArgs;
    List<int> correct = args.correct;
    TextStyle tableTextincorecctStyle = GoogleFonts.openSans(
        fontSize: 20, color: Colors.black87, decoration: TextDecoration.none);
    TextStyle tableTextcorrectStyle = GoogleFonts.openSans(
        fontSize: 20, color: Colors.red[400], decoration: TextDecoration.none);
    return SafeArea(
      child: Stack(children: [
        Column(
          children: <Widget>[
            Expanded(
                flex: 13,
                child: Container(
                  color: Colors.yellow[50],
                  child: Center(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Center(
                              child: Text(
                                correct
                                        .where((element) => element == 1)
                                        .toList()
                                        .length
                                        .toString() +
                                    '/' +
                                    args.ans.length.toString(),
                                style: TextStyle(
                                    fontSize: 40,
                                    decoration: TextDecoration.none,
                                    color: Colors.green[300]),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: SingleChildScrollView(
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const <int, TableColumnWidth>{
                                  0: IntrinsicColumnWidth(),
                                  1: FlexColumnWidth(),
                                  2: FlexColumnWidth(),
                                  3: FlexColumnWidth()
                                },
                                border: TableBorder.all(
                                    color: Colors.green.shade700, width: 2.0),
                                children: <TableRow>[
                                  TableRow(children: [
                                    Text(
                                      'id',
                                      style: tableTextincorecctStyle,
                                    ),
                                    Text(
                                      'Your ans',
                                      style: tableTextincorecctStyle,
                                    ),
                                    Text(
                                      'Ans',
                                      style: tableTextincorecctStyle,
                                    ),
                                    Text(
                                      'exp',
                                      style: tableTextincorecctStyle,
                                    )
                                  ]),
                                  for (int i = 0; i < args.ans.length; i++)
                                    TableRow(children: [
                                      Text(
                                        args.quest[i].id.toString(),
                                        style: (correct[i] == 1)
                                            ? tableTextcorrectStyle
                                            : tableTextincorecctStyle,
                                      ),
                                      Text(
                                        args.uans[i],
                                        style: (correct[i] == 1)
                                            ? tableTextcorrectStyle
                                            : tableTextincorecctStyle,
                                      ),
                                      Text(
                                        args.ans[i],
                                        style: (correct[i] == 1)
                                            ? tableTextcorrectStyle
                                            : tableTextincorecctStyle,
                                      ),
                                      Text(
                                        args.exp[i],
                                        style: (correct[i] == 1)
                                            ? tableTextcorrectStyle
                                            : tableTextincorecctStyle,
                                      )
                                    ]),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 7,
                child: Container(
                  color: Colors.yellow[50],
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: size.height / 800,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            10, size.height * 0.02, 10, size.height * 0.02),
                        child: ElevatedButton(
                            onPressed: () async {
                              print(ResultPageArgs.test);
                              print(correct);
                              setState(() {
                                visible = true;
                              });
                              if (ResultPageArgs.test != 0) {
                                await http_level(args.quest, correct);
                              } else {
                                await http_update(args.quest, correct);
                              }
                              setState(() {
                                visible = false;
                              });
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/menu', (_) => false);
                            },
                            child: Text('Home',
                                style: GoogleFonts.openSans(fontSize: 18))),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            10, size.height * 0.02, 10, size.height * 0.02),
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                visible = true;
                              });
                              if (ResultPageArgs.test != 0) {
                                await http_level(args.quest, correct);
                              } else {
                                await http_update(args.quest, correct);
                              }
                              setState(() {
                                visible = false;
                              });
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/select', ModalRoute.withName('/menu'));
                            },
                            child: Text('Menu',
                                style: GoogleFonts.openSans(fontSize: 18))),
                      )
                    ],
                  ),
                ))
          ],
        ),
        Case(size: size),
        Gauge(
            size: size,
            point: UserArgs.current_point,
            maxpoint: UserArgs.maxpoint),
        Level(level: UserArgs.level),
        Point(point: UserArgs.current_point, maxpoint: UserArgs.maxpoint),
        if (levelup)
          Align(
            alignment: Alignment(0, -0.83),
            child: Text(
              "New questions are available !",
              style: tableTextcorrectStyle,
            ),
          ),
        OverlayLoadingMolecules(
          visible: visible,
          width: MediaQuery.of(context).size.width,
        )
      ]),
    );
  }

  Future<void> caluculate_point(
      List<Question> quest, List<int> rcorrect) async {
    List<int> correct = [];
    double point = UserArgs.current_point;
    double maxpoint = UserArgs.maxpoint;
    int level = UserArgs.level;
    for (int j = 0; j < 7; j++) {
      print('i:$j point:$point maxpoint:$maxpoint level:$level');
      if (rcorrect[j] == 1) {
        correct.add(quest[i].id);
        point = point + quest[j].exp;
        print('point:$point');
        if (point >= maxpoint) {
          //level up
          point = point - maxpoint;
          UserArgs.level = UserArgs.level + 1;
          UserArgs.maxpoint =
              ConfigArgs.llist[UserArgs.level.toString()].toDouble();
          maxpoint = UserArgs.maxpoint;
          print('maxpoint:$maxpoint');
        }
      }
    }
    UserArgs.current_point = point;
  }

  Future<void> http_level(List<Question> quest, List<int> rcorrect) async {
    List<String> rank = ["", "beginner", "intermidiate", "expert"];
    List<int> correct = [];
    for (int i = 0; i < 7; i++) {
      if (rcorrect[i] == 1) {
        correct.add(quest[i].id);
      }
    }

    late String _content;
    String url = ConfigArgs.url + "level";
    Map<String, String> headers = {'content-type': 'application/json'};
    var id;
    await getDeviceUniqueId().then((value) => id = value);
    var jsonstring = {
      "device": id,
      "level": rank[ResultPageArgs.test],
      "id": correct,
    };
    String body = json.encode(jsonstring);
    http.Response resp =
        await http.post(Uri.parse(url), headers: headers, body: body);
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
    print(_content);
  }

  Future<void> http_update(List<Question> quest, List<int> rcorrect) async {
    List<int> correct = [];
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now);
    for (int i = 0; i < 7; i++) {
      if (rcorrect[i] == 1) {
        correct.add(quest[i].id);
      }
    }

    late String _content;
    String url = ConfigArgs.url + "user";
    Map<String, String> headers = {'content-type': 'application/json'};
    var id;
    await getDeviceUniqueId().then((value) => id = value);
    var jsonstring = {
      "device": id,
      "level": UserArgs.level,
      "point": UserArgs.current_point,
      "correct": correct,
      "date": date
    };
    String body = json.encode(jsonstring);
    http.Response resp =
        await http.post(Uri.parse(url), headers: headers, body: body);
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
    print(_content);
    if (RegExp(r'Badge').hasMatch(_content)) {
      List<String> list = _content.split('Badge');
      print(list);
      for (int i = 1; i < list.length; i++) {
        int count = int.parse(list[i]);
        UserArgs.badgelist[count] = true;
      }
    }
  }
}
