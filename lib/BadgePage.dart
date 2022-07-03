import 'package:flutter/material.dart';
import 'package:sample2/BadgeDetailPage.dart';
import 'package:sample2/TopPage.dart';

class BadgesPage extends StatefulWidget {
  BadgesPage({Key? key}) : super(key: key);

  @override
  _BadgesPageState createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  @override
  Widget build(BuildContext context) {
    int arg = 0;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Badge"),
        ),
        body: Container(
          child: GridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 1,
            childAspectRatio: 2,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: UserArgs.badgelist[1]
                      ? Image.asset(
                          'image/badge1.png',
                          width: size.width / 2,
                        )
                      : Image.asset(
                          'image/waku.png',
                          width: size.width / 2,
                        ),
                ),
                onTap: () {
                  arg = UserArgs.badgelist[1] ? 1 : 0;
                  Navigator.of(context).pushNamed('/badgedetail',
                      arguments: BadgeDetailPageArgs(arg));
                },
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: UserArgs.badgelist[2]
                          ? Image.asset(
                              'image/badge2.png',
                              width: size.width / 2,
                            )
                          : Image.asset(
                              'image/waku.png',
                              width: size.width / 2,
                            ),
                    ),
                    onTap: () {
                      arg = UserArgs.badgelist[2] ? 2 : 0;
                      Navigator.of(context).pushNamed('/badgedetail',
                          arguments: BadgeDetailPageArgs(arg));
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: UserArgs.badgelist[3]
                          ? Image.asset(
                              'image/badge3.png',
                              width: size.width / 2,
                            )
                          : Image.asset(
                              'image/waku.png',
                              width: size.width / 2,
                            ),
                    ),
                    onTap: () {
                      arg = UserArgs.badgelist[3] ? 3 : 0;
                      Navigator.of(context).pushNamed('/badgedetail',
                          arguments: BadgeDetailPageArgs(arg));
                    },
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: UserArgs.badgelist[4]
                          ? Image.asset(
                              'image/badge4.png',
                              width: size.width / 2,
                            )
                          : Image.asset(
                              'image/waku.png',
                              width: size.width / 2,
                            ),
                    ),
                    onTap: () {
                      arg = UserArgs.badgelist[4] ? 4 : 0;
                      Navigator.of(context).pushNamed('/badgedetail',
                          arguments: BadgeDetailPageArgs(arg));
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: UserArgs.badgelist[5]
                          ? Image.asset(
                              'image/badge5.png',
                              width: size.width / 2,
                            )
                          : Image.asset(
                              'image/waku.png',
                              width: size.width / 2,
                            ),
                    ),
                    onTap: () {
                      arg = UserArgs.badgelist[5] ? 5 : 0;
                      Navigator.of(context).pushNamed('/badgedetail',
                          arguments: BadgeDetailPageArgs(arg));
                    },
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: UserArgs.badgelist[6]
                          ? Image.asset(
                              'image/badge6.png',
                              width: size.width / 2,
                            )
                          : Image.asset(
                              'image/waku.png',
                              width: size.width / 2,
                            ),
                    ),
                    onTap: () {
                      arg = UserArgs.badgelist[6] ? 6 : 0;
                      Navigator.of(context).pushNamed('/badgedetail',
                          arguments: BadgeDetailPageArgs(arg));
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: UserArgs.badgelist[7]
                          ? Image.asset(
                              'image/badge7.png',
                              width: size.width / 2,
                            )
                          : Image.asset(
                              'image/waku.png',
                              width: size.width / 2,
                            ),
                    ),
                    onTap: () {
                      arg = UserArgs.badgelist[7] ? 7 : 0;
                      Navigator.of(context).pushNamed('/badgedetail',
                          arguments: BadgeDetailPageArgs(arg));
                    },
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: UserArgs.badgelist[8]
                          ? Image.asset(
                              'image/badge8.png',
                              width: size.width / 2,
                            )
                          : Image.asset(
                              'image/waku.png',
                              width: size.width / 2,
                            ),
                    ),
                    onTap: () {
                      arg = UserArgs.badgelist[8] ? 8 : 0;
                      Navigator.of(context).pushNamed('/badgedetail',
                          arguments: BadgeDetailPageArgs(arg));
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: UserArgs.badgelist[9]
                          ? Image.asset(
                              'image/badge9.png',
                              width: size.width / 2,
                            )
                          : Image.asset(
                              'image/waku.png',
                              width: size.width / 2,
                            ),
                    ),
                    onTap: () {
                      arg = UserArgs.badgelist[9] ? 9 : 0;
                      Navigator.of(context).pushNamed('/badgedetail',
                          arguments: BadgeDetailPageArgs(arg));
                    },
                  )
                ],
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: UserArgs.badgelist[10]
                      ? Image.asset(
                          'image/badge10.png',
                          width: size.width / 2,
                        )
                      : Image.asset(
                          'image/waku.png',
                          width: size.width / 2,
                        ),
                ),
                onTap: () {
                  arg = UserArgs.badgelist[10] ? 10 : 0;
                  Navigator.of(context).pushNamed('/badgedetail',
                      arguments: BadgeDetailPageArgs(arg));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
