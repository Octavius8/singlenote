import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../_config.dart';
import '_log.dart';

class Weather {
  String weatherKey = Config.WEATHER_KEY;
  Log log;
  Weather({required this.log});

  Future<String> getTime(String town) async {
    String logPrefix = "Weather | getTime()";
    String finalResponse = "";
    String url = "https://api.weatherapi.com/v1/forecast.json?key=$weatherKey%20&q=$town&days=1&aqi=no&alerts=no";
    try {
      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> jsontemp = jsonDecode(response.body);
      finalResponse = jsontemp["current"]["last_updated"].substring(jsontemp["current"]["last_updated"].length - 5);
    } catch (ex) {
      log.error(logPrefix, ex.toString());
    }
    return finalResponse;
  }

  Future<String> getTemperature(String town) async {
    String logPrefix = "Weather | getTemperature()";
    String finalResponse = "";
    String url = "https://api.weatherapi.com/v1/forecast.json?key=$weatherKey%20&q=$town&days=1&aqi=no&alerts=no";
    try {
      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> jsontemp = jsonDecode(response.body);
      finalResponse = jsontemp["current"]["temp_c"].toString();
      log.info(logPrefix, finalResponse);
    } catch (ex) {
      log.error(logPrefix, ex.toString());
    }
    return finalResponse;
  }

  Future<String> getCondition(String town) async {
    String logPrefix = "Weather | getCondition()";
    String finalResponse = "";
    String url = "https://api.weatherapi.com/v1/forecast.json?key=$weatherKey%20&q=$town&days=1&aqi=no&alerts=no";
    try {
      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> jsontemp = jsonDecode(response.body);
      finalResponse = jsontemp["current"]["condition"]["text"].toString();
      log.info(logPrefix, finalResponse);
    } catch (ex) {
      log.error(logPrefix, ex.toString());
    }
    return finalResponse;
  }
}
