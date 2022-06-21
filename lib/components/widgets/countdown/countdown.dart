import 'package:flutter/material.dart';
import '../../../utils/_config.dart';
import '../../../utils/_log.dart';
import '../../../model/_user.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class CountDown extends StatefulWidget {
  int index;
  String narration;
  int seconds;
  User user;
  CountDown({this.index = 0, this.narration = "Counter", this.seconds = 0, required this.user});

  @override
  CountDownState createState() => CountDownState();
}

// NOTE: If you look at the source code for this app, you'll notice that
// all animation related code is omitted here. I will be added in as the lesson
// progresses.

class CountDownState extends State<CountDown> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            width: Config.WIDGET_WIDTH,
            height: Config.WIDGET_HEIGHT,
            child: Column(children: [
              Icon(Icons.av_timer),
              Text("Timer")
            ])));
  }
}
