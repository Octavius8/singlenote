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
  late Weather weatherObject;
  Log log = new Log();
  String primaryTime = "";
  String primaryTemperature = "";
  String primaryCondition = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 5), (Timer t) => updateData());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void updateData() async {
    weatherObject = new Weather(log: log);
    bool status = await weatherObject.getData(widget.city);
    primaryTime = weatherObject.time;
    primaryCondition = weatherObject.condition;
    primaryTemperature = weatherObject.temperature;
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
            child: FutureBuilder<String>(
                future: primaryCondition,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData && snapshot.connectionState != ConnectionState.waiting) {
                    return Column(children: [
                      Text(Config.MAINCITY, style: TextStyle(fontSize: 8)),
                      Text(primaryTime,
                          style: TextStyle(
                            color: Color(0xFF62d9b5),
                          )),
                      Text("${snapshot.data} $primaryTemperature°", style: TextStyle(fontSize: 8)),
                    ]);
                  }
                  return Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF62d9b5))),
                    ),
                  );
                })));
  }
}
