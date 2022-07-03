import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:google_fonts/google_fonts.dart';
import 'package:sample2/ResultPage.dart';
import 'package:sample2/SignUpPage.dart';
import 'package:sample2/TopPage.dart';
import "package:intl/intl.dart";

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static int D = 0;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentDate = DateTime.now();
  static List<DateTime> _alldate = [];
  static EventList<Event> _markedDataMap = EventList<Event>(events: {});

  void onDayPressed(DateTime date, List<Event> events) {
    this.setState(() => _selectedDate = date);
  }

  Event createEvent(DateTime date) {
    return Event(
        date: date,
        title: date.day.toString(),
        icon: Icon(
          Icons.done_outline,
          color: Colors.green[200],
        ));
  }

  void initEvent() {
    if (_alldate.indexOf(_currentDate) == -1) {
      _alldate.add(_currentDate);
    }
    _markedDataMap.clear();
    for (int i = 0; i < _alldate.length; i++) {
      addEvent(_alldate[i]);
    }
  }

  void addEvent(DateTime date) {
    _markedDataMap.add(date, createEvent(date));
    if (_alldate.indexOf(date) == -1) {
      _alldate.add(date);
    }
  }

  @override
  void initState() {
    super.initState();
    _alldate.clear();
    ResultPageArgs.test = 0;
    for (int i = 0; i < UserArgs.date.length; i++) {
      _alldate.add(DateFormat('yyyy-MM-dd').parse(UserArgs.date[i]));
    }
    _alldate = _alldate.toSet().toList();
    if (D == 0) {
      initEvent();
      D++;
    } else {
      D = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = UserArgs.size;
    int level = UserArgs.level;
    double point = UserArgs.current_point;
    double maxpoint = UserArgs.maxpoint;
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Center(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: size.height * 0.6,
                    child: CalendarCarousel<Event>(
                        markedDatesMap: _markedDataMap,
                        onDayPressed: onDayPressed,
                        weekendTextStyle: TextStyle(color: Colors.red),
                        weekFormat: false,
                        locale: 'JA',
                        height: 800,
                        width: 392,
                        selectedDateTime: _selectedDate,
                        daysHaveCircularBorder: true,
                        customGridViewPhysics: NeverScrollableScrollPhysics(),
                        markedDateShowIcon: true,
                        markedDateIconMaxShown: 2,
                        todayButtonColor: Colors.green.shade200,
                        todayTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        markedDateIconBuilder: (event) {
                          return event.icon;
                        },
                        todayBorderColor: Colors.green.shade200,
                        selectedDayButtonColor: Colors.white,
                        selectedDayBorderColor: Colors.blue.shade300,
                        selectedDayTextStyle: TextStyle(color: Colors.black),
                        markedDateMoreShowTotal: false),
                  ),
                ),
                Container(
                  height: size.height * 0.4,
                  child: GridView.count(
                    crossAxisSpacing: 1,
                    crossAxisCount: 2,
                    childAspectRatio: size.height / 900,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            10, size.height * 0.1, 10, size.height * 0.1),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/select');
                          },
                          child: Text(
                            'Question',
                            style: GoogleFonts.openSans(fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            10, size.height * 0.1, 10, size.height * 0.1),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/score');
                          },
                          child: Text(
                            'Score',
                            style: GoogleFonts.openSans(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
          Case(size: size),
          Gauge(size: size, point: point, maxpoint: maxpoint),
          Level(level: level),
          Point(point: point, maxpoint: maxpoint),
        ]),
      ),
    );
  }
}
