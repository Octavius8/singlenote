import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/_log.dart';
import '../components/widgets/international_clock/international_clock.dart';
import '../components/widgets/white_noise/white_noise.dart';
import '../components/widgets/counter/counter.dart';
import '../components/widgets/countdown/countdown.dart';

class UserWidget {
  String type;
  String? narration;
  Color highlightColor;
  Map<String, String>? options;

  UserWidget(
      {required this.type,
      this.narration,
      this.options,
      required this.highlightColor});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> finalMap = new Map();
    finalMap['type'] = type;
    finalMap['narration'] = narration;
    finalMap['options'] = options;
    return finalMap;
  }

  Widget toFlutterWidget() {
    Widget? widget;
    Log log = new Log();
    //International Clock Widgets
    if (type == "international_clock") {
      log.debug(
          "UserWidget | toFlutterWidget", "Widget is international_clock");
      widget = InternationalClock(
          city: options?["city"] ?? "",
          highlightColor: highlightColor,
          narration: narration ?? "");
    }

    //White Noise Widgets
    if (type == "white_noise") {
      log.debug("UserWidget | toFlutterWidget", "Widget is white_noise");
      widget = WhiteNoise(
          highlightColor: highlightColor,
          audioFile: options!["audioFile"] ?? "",
          narration: narration ?? "");
    }

    //Counter Widget
    if (type == "counter") {
      log.debug("UserWidget | toFlutterWidget", "Widget is counter");
      widget = Counter(
          index: 0,
          narration: narration ?? "",
          count: int.parse(options!["count"] ?? ""),
          highlightColor: highlightColor);
    }

    //Count Down Widget
    if (type == "countdown") {
      log.debug("UserWidget | toFlutterWidget", "Widget is count_down");
      widget = CountDown(
          narration: narration ?? "",
          seconds: int.parse(options!["seconds"] ?? ""),
          highlightColor: highlightColor,
          voicePrompt: options!["voicePrompt"] == "true" ? true : false);
    }

    return widget!;
  }
}
