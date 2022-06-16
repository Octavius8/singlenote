import 'package:flutter/material.dart';
import '../../../utils/_config.dart';
import '../../../utils/_log.dart';
import '../../../model/_user.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class Counter extends StatefulWidget {
  int index;
  String narration;
  int count;
  User user;
  Counter({this.index = 0, this.narration = "Counter", this.count = 0, required this.user});

  @override
  CounterState createState() => CounterState();
}

// NOTE: If you look at the source code for this app, you'll notice that
// all animation related code is omitted here. I will be added in as the lesson
// progresses.

class CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Column(children: [
          Text(widget.count.toString(), style: TextStyle(color: widget.user.data?['color_highlight'])),
          Text(widget.narration, style: TextStyle(fontSize: Config.WIDGET_FONTSIZE))
        ]));
  }
}
