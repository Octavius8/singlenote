import 'package:flutter/material.dart';
import 'widgets/international_clock/international_clock.dart';
import 'widgets/white_noise/white_noise.dart';
import 'widgets/counter/counter.dart';
import 'widgets/countdown/countdown.dart';
import '../model/_userWidget.dart';
import '../utils/_config.dart';
import 'dart:async';
import '../model/_userData.dart';
import 'package:screenshot/screenshot.dart';
import '../utils/_log.dart';
import 'dart:io';

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
  Log log = new Log();

  @override
  void initState() {
    super.initState();
    widget.user.addListener(() {
      log.debug(
          "NoteList | initState()", "NoteList received notification of change");

      setState(() {});
    });
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
            child: Row(children: userWidgetsModel!.getFlutterWidgets())));
  }
}

class UserWidgetsModel {
  UserData user;
  Log log = new Log();

  UserWidgetsModel({required this.user});

  List<Widget> getFlutterWidgets() {
    List<Widget> finalList = [];
    List<UserWidget> userWidgetList = user.getAllUserWidgets();
    userWidgetList.forEach((userWidget) {
      try {
        finalList.add(userWidget.toFlutterWidget());
      } catch (ex) {
        log.error("UserWidgetModel | getFlutterWidgets()",
            "Failure:" + ex.toString());
      }
    });
    log.info("UserWidgetsModel | getFlutterWidgets",
        "Total user widgets: " + finalList.length.toString());

    return finalList;
  }

  List<Widget> getWidgetCatalogue(
      {required Function dragFunction, required Function dropFunction}) {
    Color highlightColor = Color(
        int.parse("FF" + user.data?['mobileApp']['highlightColor'], radix: 16));
    List<Widget> finalList = [];

    //International Clock Widgets
    ScreenshotController internationalClockScreenshotController =
        ScreenshotController();

    UserWidget internationalClock = new UserWidget(
        type: "international_clock",
        narration: "International Clock",
        widgetID: DateTime.now().millisecondsSinceEpoch.toString(),
        options: {"city": "Lusaka"},
        highlightColor: highlightColor);

    Widget draggableInternationalClock = Draggable(
        child: internationalClock.toFlutterWidget(),
        feedback: Icon(Icons.add_box),
        onDragStarted: () {
          dragFunction();
        },
        onDragEnd: (DraggableDetails) {
          dropFunction(internationalClock);
        });

    finalList.add(draggableInternationalClock);
    log.debug("UserWidgetsModel | getWidgetCatalogue",
        "Added one widget to the list. International Clock");

    //White Noise Widgets
    ScreenshotController whiteNoiseScreenshotController =
        ScreenshotController();

    UserWidget whiteNoise = new UserWidget(
        type: "white_noise",
        narration: "White Noise",
        widgetID: DateTime.now().millisecondsSinceEpoch.toString(),
        options: {"audioFile": "ship"},
        highlightColor: highlightColor);

    Widget draggableWhiteNoise = Draggable(
        child: whiteNoise.toFlutterWidget(),
        feedback: Icon(Icons.add_box),
        onDragStarted: () {
          dragFunction();
        },
        onDragEnd: (DraggableDetails) {
          dropFunction(whiteNoise);
        });

    finalList.add(draggableWhiteNoise);
    log.debug("UserWidgetsModel | getWidgetCatalogue",
        "Added one widget to the list. White List");

    //Counter Widget
    ScreenshotController counterScreenshotController = ScreenshotController();

    UserWidget counter = new UserWidget(
        type: "counter",
        narration: "Counter",
        widgetID: DateTime.now().millisecondsSinceEpoch.toString(),
        options: {"count": "0"},
        highlightColor: highlightColor);

    Widget draggableCounter = Draggable(
        child: counter.toFlutterWidget(),
        feedback: Icon(Icons.add_box),
        onDragStarted: () {
          dragFunction();
        },
        onDragEnd: (DraggableDetails) {
          dropFunction(counter);
        });

    finalList.add(draggableCounter);
    log.debug("UserWidgetsModel | getWidgetCatalogue",
        "Added one widget to the list. Counter");

    //Count Down Widget
    ScreenshotController countDownScreenshotController = ScreenshotController();

    UserWidget countDown = new UserWidget(
        type: "countdown",
        narration: "Timer",
        widgetID: DateTime.now().millisecondsSinceEpoch.toString(),
        options: {"seconds": "300"},
        highlightColor: highlightColor);

    Widget draggableCountDown = Draggable(
        child: countDown.toFlutterWidget(),
        feedback: Icon(Icons.add_box),
        onDragStarted: () {
          dragFunction();
        },
        onDragEnd: (DraggableDetails) {
          dropFunction(countDown);
        });

    finalList.add(draggableCountDown);
    log.debug("UserWidgetsModel | getWidgetCatalogue",
        "Added one widget to the list. CountDown");

    return finalList;
  }
}
