import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BadgeDetailPageArgs {
  int badge = 0;
  BadgeDetailPageArgs(this.badge);
}

class BadgeDetailPage extends StatefulWidget {
  BadgeDetailPage({Key? key}) : super(key: key);

  @override
  _BadgeDetailPageState createState() => _BadgeDetailPageState();
}

class _BadgeDetailPageState extends State<BadgeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BadgeDetailPageArgs;
    String name = (args.badge != 0)
        ? 'image/badge' + args.badge.toString() + '.png'
        : 'image/waku.png';
    List<String> badgename = [
      "???",
      "CQ Hello World",
      "C言語 初学者",
      "C言語 初心者",
      "C言語 文法1修了",
      "C言語 脱初心者",
      "C言語 中級者",
      ".C言語 文法2修了",
      "C言語 上級者への道",
      "C言語 ナゼカウゴカナイ",
      "C言語 ﾁｮｯﾄﾃﾞｷﾙ"
    ];
    List<String> message = [
      "",
      "最初の7問を正解する。",
      "初級の10問を正解する。",
      "初級の30問を正解する。",
      "初級の全ての問題を正解する。",
      "中級の10問を正解する。",
      "ポインタ、配列の問題を全て正解する。",
      "中級の問題を全て正解する。",
      "上級の問題を10問正解する。",
      "上級の問題を15問正解する。。",
      "上級の問題を全て正解する。"
    ];
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        Container(
          color: Colors.yellow[50],
          child: Column(
            children: [
              Container(margin: EdgeInsets.all(10), child: Image.asset(name)),
              Container(
                margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: badgename[args.badge] + "\n",
                      style: GoogleFonts.openSans(
                          fontSize: 35, color: Colors.black),
                    ),
                    TextSpan(
                      text: message[args.badge],
                      style: GoogleFonts.openSans(
                          fontSize: 20, color: Colors.black),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment(1.0, 0.5),
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Back")),
        )
      ]),
    ));
  }
}
