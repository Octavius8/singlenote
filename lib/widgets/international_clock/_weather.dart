import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../_config.dart';
import '../../model/_log.dart';

class Weather {
  String weatherKey = Config.WEATHER_KEY;
  String time = "";
  String condition = "";
  String temperature = "";
  Log log;
  Weather({required this.log});

  Future<bool> getData(String town) async {
    String logPrefix = "Weather | getTime()";
    bool finalResponse = false;
    String url = "https://api.weatherapi.com/v1/forecast.json?key=$weatherKey%20&q=$town&days=1&aqi=no&alerts=no";
    try {
      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> jsontemp = jsonDecode(response.body);
      this.time = jsontemp["current"]["last_updated"].substring(jsontemp["current"]["last_updated"].length - 5);
      this.temperature = jsontemp["current"]["temp_c"].toString();
      this.condition = jsontemp["current"]["condition"]["text"].toString();
      finalResponse = true;
    } catch (ex) {
      log.error(logPrefix, ex.toString());
      finalResponse = false;
    }
    return finalResponse;
  }
}
