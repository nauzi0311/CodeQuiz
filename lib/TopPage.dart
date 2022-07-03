import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";

import 'package:sample2/DeviceInfo.dart';
import 'package:sample2/OverlayLoadingMolecules.dart';

class TopPage extends StatefulWidget {
  TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class ConfigArgs {
  static List<int> Cbava = [0, 7, 11, 13, 15, 18, 21, 23, 25, 30, 32];
  static List<int> Cmava = [7, 9, 11, 13, 15, 17, 19, 21, 23, 24]; //from level6
  static List<int> Chava = [7, 7]; //from level12
  static int openCm = 6;
  static int openCh = 12;
  static Map<String, dynamic> llist = {};
  //Android Emulatorでは、localhostではなく、10.0.2.2が使われるそう。
  //https://sunnyday-travel-aso-6487.ssl-lolipop.jp/programing/flutter/socketexception/
  static String url = "https://se.is.kit.ac.jp/beakfish/node/";
}

class UserArgs {
  static double current_point = 0, maxpoint = 70;
  static int level = 1;
  static Size size = Size(0, 0);
  static List<String> date = [];
  static List<bool> badgelist = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
}

class _TopPageState extends State<TopPage> {
  bool select = true;
  bool visible = false;
  int status = 0;
  var id;
  @override
  void initState() {
    super.initState();
    getDeviceUniqueId().then((value) => id = value);
  }

  @override
  Widget build(BuildContext context) {
    UserArgs.size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        InkWell(
          onTap: () async {
            setState(() {
              visible = true;
            });
            var _content;
            String url = ConfigArgs.url + "index";
            http.Response resp = await http.get(Uri.parse(url));
            Map<String, String> headers = {'content-type': 'application/json'};
            var jsonstring = {"device": id};
            String body = json.encode(jsonstring);
            resp =
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

            if (_content == "new") {
              Navigator.of(context).pushNamed('/signup');
            } else {
              Map<String, dynamic> map = jsonDecode(_content);
              var config = map['config'];
              ConfigArgs.llist = config['level'];
              ConfigArgs.Cbava = config['Cbava'].cast<int>();
              ConfigArgs.Cmava = config['Cmava'].cast<int>();
              ConfigArgs.Chava = config['Chava'].cast<int>();
              UserArgs.level = map['level'];
              UserArgs.current_point = map['point'].toDouble();
              UserArgs.maxpoint =
                  ConfigArgs.llist[UserArgs.level.toString()].toDouble();
              UserArgs.size = MediaQuery.of(context).size;
              for (int i = 0; i < map['date'].length; i++) {
                final formatter = new DateFormat('yyyy-MM-dd');
                DateTime datetime = DateTime.parse(map['date'][i]);
                UserArgs.date.add(formatter.format(datetime));
              }
              UserArgs.date = UserArgs.date.toSet().toList();
              for (int i = 0; i < map['badge'].length; i++) {
                UserArgs.badgelist[i] = map['badge'][i];
              }
              setState(() {
                visible = false;
              });
              Navigator.of(context).pushNamed('/menu');
            }
          },
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        child: Center(
                      child: Column(
                        children: [
                          AnimatedSlide(
                            offset:
                                select ? Offset(-0.25, 1.5) : Offset(2, 1.5),
                            duration: Duration(milliseconds: 500),
                            child: Text(
                              'Code',
                              style:
                                  TextStyle(fontSize: 70, color: Colors.indigo),
                            ),
                            curve: Curves.easeInOutCubic,
                          ),
                          AnimatedSlide(
                            offset: select ? Offset(0.45, 1.6) : Offset(2, 1.6),
                            duration: Duration(milliseconds: 500),
                            child: Text(
                              'Quiz',
                              style:
                                  TextStyle(fontSize: 70, color: Colors.indigo),
                            ),
                            curve: Curves.easeInOutCubic,
                          )
                        ],
                      ),
                    )),
                  )),
              Expanded(
                flex: 4,
                child: Container(
                  child: Center(
                      child: Text('Tap', style: TextStyle(fontSize: 50))),
                ),
              ),
            ],
          ),
        ),
        OverlayLoadingMolecules(
            visible: visible, width: MediaQuery.of(context).size.width)
      ]),
    ));
  }
}
