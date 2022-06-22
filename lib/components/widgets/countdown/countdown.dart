import 'package:flutter/material.dart';
import '../../../utils/_config.dart';
import '../../../utils/_log.dart';
import '../../../model/_user.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_beep/flutter_beep.dart';
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
  Timer? timer;

  @override
  void initState() {
    super.initState();
    currentCount = widget.seconds;
    narrationTime = (widget.seconds / 60).floor().toString().padLeft(2, "0") + ":" + (widget.seconds % 60).toString().padLeft(2, "0");
  }

  void decrementCounter() {
    if (currentCount > 0 && countingDown) {
      currentCount = currentCount - 1;
      int minutes = (currentCount / 60).floor();
      int seconds = (currentCount % 60);
      narrationTime = minutes.toString().padLeft(2, "0") + ":" + seconds.toString().padLeft(2, "0");
      log.debug("CountDown | decrementCounter()", narrationTime);
    } else {
      if (currentCount == 0 && countingDown) {
        log.debug("CountDown | decrementCounter() ", "beeping...");
        FlutterBeep.beep();
        countingDown = false;
        timer?.cancel();
      }
      narrationTime = (widget.seconds / 60).floor().toString().padLeft(2, "0") + ":" + (widget.seconds % 60).toString().padLeft(2, "0");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (countingDown) {
            countingDown = false;
            timer?.cancel();
            decrementCounter();
          } else {
            currentCount = widget.seconds;
            countingDown = true;
            timer = Timer.periodic(Duration(seconds: 1), (Timer t) => decrementCounter());
          }
          setState(() {});
        },
        child: Container(
            width: Config.WIDGET_WIDTH,
            height: Config.WIDGET_HEIGHT,
            child: Column(children: [
              Text(widget.narration, style: TextStyle(fontSize: Config.WIDGET_FONTSIZE)),
              Expanded(flex: 2, child: Icon(Icons.av_timer, size: Config.WIDGET_ICONSIZE, color: countingDown ? Color(int.parse("FF" + widget.user.data?["color_highlight"], radix: 16)) : null)),
              Text(narrationTime, style: TextStyle(fontSize: Config.WIDGET_FONTSIZE, color: countingDown ? Color(int.parse("FF" + widget.user.data?["color_highlight"], radix: 16)) : null))
            ])));
  }
}
