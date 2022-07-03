import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample2/TopPage.dart';
import 'package:http/http.dart' as http;

import 'DeviceInfo.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool select = true;
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
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Align(
          alignment: Alignment(0.0, -0.2),
          child: Container(
            height: 250,
            width: 300,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black54)),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Sign Up",
                    style:
                        GoogleFonts.openSans(fontSize: 20, color: Colors.black),
                  ),
                  TextFormField(
                    enabled: true,
                    controller: _ucontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username",
                        fillColor: Colors.black26),
                  ),
                  TextFormField(
                    obscureText: true,
                    enabled: true,
                    controller: _pcontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        fillColor: Colors.black26),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        late String _content;
                        String url = ConfigArgs.url + "index/signup";
                        Map<String, String> headers = {
                          'content-type': 'application/json'
                        };
                        var jsonstring = {
                          "device": id,
                          "username": _ucontroller.text,
                          "password": _pcontroller.text
                        };
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
                        print(_content);
                        Map<String, dynamic> config = jsonDecode(_content);
                        ConfigArgs.llist = config['level'];
                        ConfigArgs.Cbava = config['Cbava'].cast<int>();
                        ConfigArgs.Cmava = config['Cmava'].cast<int>();
                        ConfigArgs.Chava = config['Chava'].cast<int>();
                        UserArgs.current_point = 0;
                        UserArgs.level = 1;
                        UserArgs.maxpoint = 70;
                        UserArgs.size = MediaQuery.of(context).size;
                        print(_content);
                        Navigator.pushReplacementNamed(
                          context,
                          '/selectlevel',
                        );
                      },
                      child: Text("Sign up"))
                ],
              ),
            ),
          ),
        ),
      ]),
    ));
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
