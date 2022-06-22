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
  CountDown({this.index = 0, this.narration = "Count Down", this.seconds = 0, required this.user});

  @override
  CountDownState createState() => CountDownState();
}

// NOTE: If you look at the source code for this app, you'll notice that
// all animation related code is omitted here. I will be added in as the lesson
// progresses.

class CountDownState extends State<CountDown> {
  bool countingDown = false;
  int currentCount = 0;
  String narrationTime = "";
  Log log = new Log();

  @override
  void initState() {
    super.initState();
    currentCount = widget.seconds;
    Timer.periodic(Duration(seconds: 3), (Timer t) => decrementCounter());
  }

  void decrementCounter() {
    if (currentCount > 0 && countingDown) {
      currentCount = currentCount - 1;
      int minutes = (currentCount / 60).floor();
      int seconds = widget.seconds - (minutes / 60).floor();
      narrationTime = minutes.toString() + ":" + seconds.toString();
      log.debug("CountDown | decrementCounter()", narrationTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (countingDown)
            countingDown = false;
          else {
            currentCount = widget.seconds;
            countingDown = true;
          }
          setState(() {});
        },
        child: Container(
            width: Config.WIDGET_WIDTH,
            height: Config.WIDGET_HEIGHT,
            child: Column(children: [
              Expanded(flex: 2, child: countingDown ? Text(narrationTime) : Icon(Icons.av_timer, size: Config.WIDGET_ICONSIZE)),
              Text(widget.narration, style: TextStyle(fontSize: Config.WIDGET_FONTSIZE))
            ])));
  }
}
