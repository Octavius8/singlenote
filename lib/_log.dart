import 'dart:convert';
import 'package:intl/intl.dart';

class Log {
  String logString = "";

  void error(String logPrefix, String message) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    this.logString = this.logString +
        "\n" +
        formattedDate +
        "| ERROR | " +
        logPrefix +
        "|" +
        message;
  }

  void info(String logPrefix, String message) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    this.logString = this.logString +
        "\n" +
        formattedDate +
        "| INFO | " +
        logPrefix +
        "|" +
        message;
  }
}

/*
* ToDo:
*  - Add third method that has everything in common between the two.
*/
