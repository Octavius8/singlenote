import 'package:flutter/material.dart';
import 'widgets/international_clock/international_clock.dart';
import 'widgets/white_noise/white_noise.dart';
import 'widgets/counter/counter.dart';
import '../utils/_config.dart';
import 'dart:async';
import 'widgets/countdown/countdown.dart';
import '../model/_userData.dart';

class PrimaryWidgetArea extends StatefulWidget {
  UserData user;
  PrimaryWidgetArea({required this.user});
  @override
  State<StatefulWidget> createState() {
    return new PrimaryWidgetAreaState();
  }
}

class PrimaryWidgetAreaState extends State<PrimaryWidgetArea> {
  UserWidgetsModel? userWidgetsModel;

  @override
  void initState() {
    super.initState();
    userWidgetsModel = new UserWidgetsModel(user: widget.user);
  }

  Widget build(BuildContext context) {
    return Container(
        width: Config.WIDGET_NUMBER_TO_DISPLAY * Config.WIDGET_WIDTH,
        /*decoration: BoxDecoration(
            border: Border(
                right: BorderSide(width: 1, color: Config.COLOR_))),*/
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: userWidgetsModel!.compileListOfWidgets())));
  }
}

class UserWidgetsModel {
  UserData user;

  UserWidgetsModel({required this.user});

  List<Widget> compileListOfWidgets() {
    List<Widget> finalList = [];
    int index = 0;
    user.data?['mobile_app']['primaryWidgets'].forEach((minwidget) {
      //International Clock Widgets
      if (minwidget["type"] == "international_clock") {
        finalList.add(InternationalClock(
            city: minwidget["city"],
            highlightColor: Color(int.parse(
                "FF" + user.data?['mobile_app']['highlightColor'],
                radix: 16))));
      }

      //White Noise Widgets
      if (minwidget["type"] == "white_noise") {
        finalList.add(WhiteNoise(
            highlightColor: Color(int.parse(
                "FF" + user.data?['mobile_app']['highlightColor'],
                radix: 16)),
            audioFile: minwidget["audioFile"],
            narration: minwidget["narration"]));
      }

      //Counter Widget
      if (minwidget["type"] == "counter") {
        finalList.add(Counter(
            index: index,
            narration: minwidget["narration"],
            count: int.parse(minwidget["count"]),
            highlightColor: Color(int.parse(
                "FF" + user.data?['mobile_app']['highlightColor'],
                radix: 16))));
      }

      //Count Down Widget
      if (minwidget["type"] == "countdown") {
        finalList.add(CountDown(
            index: index,
            narration: minwidget["narration"],
            seconds: int.parse(minwidget["seconds"]),
            highlightColor: Color(int.parse(
                "FF" + user.data?['mobile_app']['highlightColor'],
                radix: 16)),
            voicePrompt: minwidget["voicePrompt"] == "true" ? true : false));
      }

      index++;
    });

    //New Icon
    finalList.add(
      Padding(
          padding: EdgeInsets.all(Config.WIDGET_WIDTH / 3),
          child: GestureDetector(
              onTap: () {
                user.resetData();
              },
              child: Icon(Icons.add_to_photos_rounded,
                  color: Color(int.parse(
                      "FF" + (user.data?["color_highlight"] ?? "000000"),
                      radix: 16)),
                  size: Config.WIDGET_WIDTH / 4))),
    );
    return finalList;
  }
}
