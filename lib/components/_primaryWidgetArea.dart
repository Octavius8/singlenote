import 'package:flutter/material.dart';
import '../model/_user.dart';
import '../widgets/international_clock/international_clock.dart';
import '../widgets/white_noise/white_noise.dart';
import '../_config.dart';
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
    return Container(width: Config.WIDGET_NUMBER_TO_DISPLAY * Config.WIDGET_WIDTH, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: compileListOfWidgets())));
  }

  List<Widget> compileListOfWidgets() {
    List<Widget> finalList = [];
    widget.user.data?['primaryWidgets'].forEach((widget) {
      if (widget["type"] == "international_clock") {
        finalList.add(InternationalClock(city: widget["city"]));
      }
    });
    return finalList;
  }
}
