import 'package:flutter/material.dart';
import '_weather.dart';
import 'dart:async';
import '../../model/_log.dart';
import '../../_config.dart';

class InternationalClock extends StatefulWidget {
  String city;
  InternationalClock({required this.city, Key? key}) : super(key: key);

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
    timer = Timer.periodic(Duration(minutes: 5), (Timer t) => updateData());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void updateData() async {
    bool status = await weatherObject?.getData(widget.city) ?? false;
    primaryTime = weatherObject?.time ?? "";
    primaryCondition = weatherObject?.condition ?? "";
    primaryTemperature = weatherObject?.temperature ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          updateData();
        },
        child: Expanded(
            flex: 3,
            //Future Builder
            child: Column(children: [
              Text(Config.MAINCITY, style: TextStyle(fontSize: 8)),
              Text(primaryTime,
                  style: TextStyle(
                    color: Color(0xFF62d9b5),
                  )),
              Text("$primaryCondition $primaryTemperature°", style: TextStyle(fontSize: 8)),
            ])));
  }
}
