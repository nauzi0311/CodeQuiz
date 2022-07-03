import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample2/OverlayLoadingMolecules.dart';
import 'package:sample2/QuestionChoicePage.dart';
import 'package:sample2/Question.dart';
import 'package:http/http.dart' as http;
import 'package:sample2/QuestionTypeHardPage.dart';
import 'package:sample2/ResultPage.dart';
import 'package:sample2/TopPage.dart';

import 'QuestionTypePage.dart';

class SelectLangPage extends StatefulWidget {
  const SelectLangPage({Key? key}) : super(key: key);

  @override
  _SelectLangPageState createState() => _SelectLangPageState();
}

class _SelectLangPageState extends State<SelectLangPage> {
  late List<Question> _Cqlist = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool visible = false;
    List<String> qnum = [];
    bool mable = false;
    bool hable = false;
    if (UserArgs.level >= ConfigArgs.openCm) mable = true;
    if (UserArgs.level >= ConfigArgs.openCh) hable = true;
    return SafeArea(
        child: Stack(children: [
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text("Select Level"),
        ),
        body: Stack(children: [
          ListView(
            children: <Widget>[
              ListTile(
                title: Text('C言語初級'),
                onTap: () async {
                  _Cqlist = [];
                  int range = (UserArgs.level < ConfigArgs.Cbava.length)
                      ? UserArgs.level
                      : ConfigArgs.Cbava.length - 1;
                  setState(() {
                    visible = true;
                  });

                  for (int i = 0; i < 7; i++) {
                    qnum.add((Random().nextInt(ConfigArgs.Cbava[range]) + 1001)
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
                      arguments: QuestionChoicePageArgs([], [], _Cqlist, []));
                },
              ),
              ListTile(
                title: Text('C言語中級'),
                onTap: () async {
                  _Cqlist = [];
                  int range = (UserArgs.level - ConfigArgs.openCm <
                          ConfigArgs.Cmava.length)
                      ? UserArgs.level - ConfigArgs.openCm
                      : ConfigArgs.Cmava.length - 1;
                  late String _content;
                  setState(() {
                    visible = true;
                  });
                  for (int i = 0; i < 7; i++) {
                    qnum.add((Random().nextInt(ConfigArgs.Cmava[range]) + 2001)
                        .toString());
                    qnum = qnum.toSet().toList();
                    if (qnum.length <= i) {
                      i--;
                      continue;
                    }
                  }
                  print(visible);

                  String url = ConfigArgs.url + "quest/flutter";
                  Map<String, String> headers = {
                    'content-type': 'application/json'
                  };
                  for (int i = 0; i < qnum.length; i++) {
                    print(visible);
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
                      arguments: QuestionTypePageArgs([], [], _Cqlist, []));
                },
                enabled: mable,
              ),
              ListTile(
                title: Text('C言語上級'),
                onTap: () async {
                  _Cqlist = [];
                  int range = (UserArgs.level - ConfigArgs.openCh <
                          ConfigArgs.Chava.length)
                      ? UserArgs.level - ConfigArgs.openCh
                      : ConfigArgs.Chava.length - 1;
                  late String _content;
                  setState(() {
                    visible = true;
                  });
                  for (int i = 0; i < 7; i++) {
                    qnum.add((Random().nextInt(ConfigArgs.Chava[range]) + 3001)
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
                      arguments: QuestionTypeHardPageArgs([], [], _Cqlist, []));
                },
                enabled: hable,
              ),
              // ListTile(
              //   title: Text('Java初級'),
              //   onTap: () {
              //     Navigator.of(context).pushNamed('/question',
              //         arguments: QuestionChoicePageArgs([], [], []));
              //   },
              // ),
              // ListTile(
              //   title: Text('Java中級'),
              //   onTap: () {
              //     Navigator.of(context).pushNamed('/question',
              //         arguments: QuestionChoicePageArgs([], [], []));
              //   },
              // ),
              // ListTile(
              //   title: Text('Java上級'),
              //   onTap: () {
              //     Navigator.of(context).pushNamed('/question');
              //   },
              // ),
            ],
          ),
          OverlayLoadingMolecules(
            visible: visible,
            width: MediaQuery.of(context).size.width,
          )
        ]),
      ),
    ]));
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
