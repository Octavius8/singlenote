import 'dart:convert';
import 'package:intl/intl.dart';
import '../_config.dart';

class Log {
  bool debugEnabled = Config.LOG_DEBUG_ENABLED;
  String logString = "";

  void error(String logPrefix, String message) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    this.logString =
        "\n" + formattedDate + "| ERROR | " + logPrefix + " | " + message;
    storeLog();
  }

  void info(String logPrefix, String message) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    this.logString =
        "\n" + formattedDate + "| INFO | " + logPrefix + " | " + message;
    storeLog();
  }

  void debug(String logPrefix, String message) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    this.logString =
        "\n" + formattedDate + "| INFO | " + logPrefix + " | " + message;
    if (debugEnabled) storeLog();
  }

  void storeLog() {
    print(this.logString);
  }
}

/*
* ToDo:
*  - Add third method that has everything in common between the two.
*/
