import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample2/OverlayLoadingMolecules.dart';
import 'package:sample2/Question.dart';
import 'package:sample2/ScoreListPage.dart';
import 'package:http/http.dart' as http;
import 'package:sample2/TopPage.dart';

class ScorePage extends StatefulWidget {
  ScorePage({Key? key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late List<Question> _Cqlist = [];
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    List<String> qnum = [];
    late String _content;
    bool mable = false;
    bool hable = false;
    if (UserArgs.level >= ConfigArgs.openCm) mable = true;
    if (UserArgs.level >= ConfigArgs.openCh) hable = true;
    return SafeArea(
        child: Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: Text("Score"),
        ),
        body: Stack(children: [
          ListView(
            children: <Widget>[
              ListTile(
                title: Text('C言語初級'),
                onTap: () async {
                  setState(() {
                    visible = true;
                  });
                  int range = (UserArgs.level < ConfigArgs.Cbava.length)
                      ? UserArgs.level
                      : ConfigArgs.Cbava.length - 1;
                  List<Question> list = [];
                  List<String> tlist = [];
                  for (int i = 0; i < ConfigArgs.Cbava[range]; i++) {
                    tlist.add((i + 1001).toString());
                  }
                  await jsonloader(tlist).then((value) => list = value);
                  setState(() {
                    visible = false;
                  });
                  Navigator.of(context).pushNamed('/slist',
                      arguments: ListPageArgs(list, 'C言語初級'));
                },
              ),
              ListTile(
                title: Text('C言語中級'),
                onTap: () async {
                  setState(() {
                    visible = true;
                  });
                  int range = (UserArgs.level - ConfigArgs.openCm <
                          ConfigArgs.Cmava.length)
                      ? UserArgs.level - ConfigArgs.openCm
                      : ConfigArgs.Cmava.length - 1;
                  String url = ConfigArgs.url + "quest/flutter";
                  Map<String, String> headers = {
                    'content-type': 'application/json'
                  };
                  for (int i = 0; i < ConfigArgs.Cmava[range]; i++) {
                    qnum.add((i + 2001).toString());
                  }
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
                  Navigator.of(context).pushNamed('/slist',
                      arguments: ListPageArgs(_Cqlist, 'C言語中級'));
                },
                enabled: mable,
              ),
              ListTile(
                title: Text('C言語上級'),
                onTap: () async {
                  setState(() {
                    visible = true;
                  });
                  int range = (UserArgs.level - ConfigArgs.openCh <
                          ConfigArgs.Chava.length)
                      ? UserArgs.level - ConfigArgs.openCh
                      : ConfigArgs.Chava.length - 1;
                  String url = ConfigArgs.url + "quest/flutter";
                  Map<String, String> headers = {
                    'content-type': 'application/json'
                  };
                  for (int i = 0; i < ConfigArgs.Chava[range]; i++) {
                    qnum.add((i + 3001).toString());
                  }
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
                  Navigator.of(context).pushNamed('/slist',
                      arguments: ListPageArgs(_Cqlist, 'C言語上級'));
                },
                enabled: hable,
              ),
              // ListTile(
              //   title: Text('Java初級'),
              // ),
              // ListTile(
              //   title: Text('Java中級'),
              // ),
              // ListTile(
              //   title: Text('Java上級'),
              // ),
            ],
          ),
          OverlayLoadingMolecules(
              visible: visible, width: MediaQuery.of(context).size.width)
        ]),
      ),
      Align(
        alignment: Alignment(1, 0.9),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/badge');
          },
          child: Text("Badges"),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(24),
          ),
        ),
      )
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

  Future<List<Question>> jsonloader(List<String> list) async {
    List<Question> value = [];
    for (int i = 0; i < list.length; i++) {
      String path = 'assets/json/' + list[i] + '.json';
      String jsonString;
      try {
        jsonString = await rootBundle.loadString(path);
      } on FlutterError {
        print('Faild to open $path');
        exit(0);
      }
      value.add(Question(
          json.decode(jsonString)['id'],
          json.decode(jsonString)['title'],
          json.decode(jsonString)['question'],
          json.decode(jsonString)['output'],
          json.decode(jsonString)['answer'],
          json.decode(jsonString)['exp'],
          json.decode(jsonString)['point']));
    }
    return value;
  }
}
