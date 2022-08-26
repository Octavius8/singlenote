import 'package:flutter/material.dart';
import '_weather.dart';
import 'dart:async';
import '../../../utils/_log.dart';
import '../../../model/_user.dart';
import '../../../utils/_config.dart';

class InternationalClock extends StatefulWidget {
  String city = "Lusaka";
  Color highlightColor;
  String narration;
  String defaultCity = Config.WIDGET_INTERNATIONAL_CLOCK_DEFAULT_CITY;

  InternationalClock(
      {this.city = "Lusaka",
      required this.narration,
      required this.highlightColor,
      Key? key})
      : super(key: key);

  @override
  InternationalClockState createState() => InternationalClockState();
}

class InternationalClockState extends State<InternationalClock> {
  Weather? weatherObject;
  Log log = new Log();
  String primaryTime = "";
  String primaryTemperature = "";
  String primaryCondition = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (widget.city == "") {
      widget.city = widget.defaultCity;
      log.debug(
          "InternationalClockState | initState", "City set is " + widget.city);
    }
    weatherObject = new Weather(log: log);
    updateData();
    timer = Timer.periodic(Duration(minutes: 5), (Timer t) => updateData());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void updateData() async {
    String logPrefix = "InternationalClock | updateData()";
    log.debug(logPrefix, "starting updateData function..");
    bool status = await weatherObject?.getData(widget.city) ?? false;
    primaryTime = weatherObject?.time ?? "";
    primaryCondition = weatherObject?.condition ?? "";
    primaryTemperature = weatherObject?.temperature ?? "";
    log.debug(logPrefix,
        "Completed fetching data for ${widget.city}. time=$primaryTime, temp=$primaryTemperature, condition=$primaryCondition");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String logPrefix = "InternationalClock | build";
    return GestureDetector(
        onTap: () {
          updateData();
        },
        child: Container(
            width: Config.WIDGET_WIDTH,
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                  widget.narration == ""
                      ? "${widget.city[0].toUpperCase()}${widget.city.substring(1).toLowerCase()}"
                      : widget.narration,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Config.WIDGET_FONTSIZE)),
              Text(primaryTime,
                  style: TextStyle(
                    color: widget.highlightColor,
                  )),
              Text("$primaryCondition $primaryTemperature°",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Config.WIDGET_FONTSIZE)),
            ])));
  }
}


//kafula mafula university