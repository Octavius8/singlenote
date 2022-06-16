import 'package:flutter/material.dart';
import '../model/_user.dart';
import 'widgets/international_clock/international_clock.dart';
import 'widgets/white_noise/white_noise.dart';
import 'widgets/counter/counter.dart';
import '../utils/_config.dart';
import 'dart:async';

class PrimaryWidgetArea extends StatefulWidget {
  User user;
  PrimaryWidgetArea({required this.user});
  @override
  State<StatefulWidget> createState() {
    return new PrimaryWidgetAreaState();
  }
}

class PrimaryWidgetAreaState extends State<PrimaryWidgetArea> {
  Widget build(BuildContext context) {
    return Container(
        width: Config.WIDGET_NUMBER_TO_DISPLAY * Config.WIDGET_WIDTH,
        /*decoration: BoxDecoration(
            border: Border(
                right: BorderSide(width: 1, color: Config.COLOR_))),*/
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: compileListOfWidgets())));
  }

  List<Widget> compileListOfWidgets() {
    List<Widget> finalList = [];
    int index = 0;
    widget.user.data?['primaryWidgets'].forEach((minwidget) {
      //International Clock Widgets
      if (minwidget["type"] == "international_clock") {
        finalList.add(InternationalClock(city: minwidget["city"], user: widget.user));
      }

      //White Noise Widgets
      if (minwidget["type"] == "white_noise") {
        finalList.add(WhiteNoise(user: widget.user, audioFile: minwidget["audioFile"], narration: minwidget["narration"]));
      }

      //Counter Widget
      if (minwidget["type"] == "counter") {
        finalList.add(Counter(index: index, narration: minwidget["narration"], count: minwidget["value"], user: widget.user));
      }

      index++;
    });
    return finalList;
  }
}
