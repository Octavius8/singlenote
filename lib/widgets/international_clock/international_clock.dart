import 'package:flutter/material.dart';
import '_weather.dart';
import 'dart:async';
import '../../model/_log.dart';
import '../../model/_user.dart';
import '../../_config.dart';

class InternationalClock extends StatefulWidget {
  String city;
  User user;
  InternationalClock({required this.city, required this.user, Key? key}) : super(key: key);

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
    primaryTime = "12:30"; //weatherObject?.time ?? "";
    primaryCondition = "Clear"; // weatherObject?.condition ?? "";
    primaryTemperature = "27"; //weatherObject?.temperature ?? "";
    log.debug(logPrefix, "Completed fetching data for ${widget.city}. time=$primaryTime, temp=$primaryTemperature, condition=$primaryCondition");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          updateData();
        },
        child: Container(
            width: Config.WIDGET_WIDTH,
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Column(children: [
              Text("${widget.city[0].toUpperCase()}${widget.city.substring(1).toLowerCase()}", style: TextStyle(fontSize: Config.WIDGET_FONTSIZE)),
              Text(primaryTime,
                  style: TextStyle(
                    color: Color(int.parse("FF" + widget.user.data?["color_highlight"] ?? "00FF00", radix: 16)),
                  )),
              Text("$primaryCondition $primaryTemperature°", textAlign: TextAlign.center, style: TextStyle(fontSize: Config.WIDGET_FONTSIZE)),
            ])));
  }
}
