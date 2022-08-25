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
    List<Widget> finalList = [];

    //International Clock Widgets
    ScreenshotController internationalClockScreenshotController =
        ScreenshotController();

    UserWidget internationalClock =
        new UserWidget(type: "international_clock", highlightColor: Colors.red);

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
        "Added one widget to the list.");

    /*finalList.add(Draggable<String>(
        data: '2',
        child: InternationalClock(
            narration: 'Kyoto',
            city: 'Kyoto',
            highlightColor: Color(int.parse(
                "FF" + user.data?['mobileApp']['highlightColor'],
                radix: 16))),
        feedback: Icon(Icons.library_add, color: Config.COLOR_LIGHTGRAY),
        onDragStarted: () {
          dragFunction.call();
        },
        onDragEnd: (DraggableDetails) {
          dropFunction.call();
        }));


    //White Noise Widgets
    finalList.add(WhiteNoise(
        highlightColor: Color(int.parse(
            "FF" + user.data?['mobileApp']['highlightColor'],
            radix: 16)),
        audioFile: 'ship',
        narration: 'White Noise'));

    //Counter Widget
    finalList.add(Counter(
        index: 0,
        narration: "Counter",
        count: 30,
        highlightColor: Color(int.parse(
            "FF" + user.data?['mobileApp']['highlightColor'],
            radix: 16))));

    //Count Down Widget
    finalList.add(CountDown(
        index: 0,
        narration: "Count Down Timer",
        seconds: 300,
        highlightColor: Color(int.parse(
            "FF" + user.data?['mobile_app']['highlightColor'],
            radix: 16)),
        voicePrompt: false));*/

    return finalList;
  }
}
