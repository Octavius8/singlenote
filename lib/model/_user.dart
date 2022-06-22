import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../utils/_log.dart';

class User {
  Log log = new Log();
  Map<String, dynamic>? data;
  String testContent = '{ "name": "Boss", "color_highlight":"62d9b5","primaryWidgets": [{ "type": "international_clock", "city": "Lusaka" },{ "type": "international_clock", "city": "Mumbai" },{ "type": "white_noise", "audioFile": "ship","narration":"White Noise" },{ "type": "counter", "narration":"Complaints","count":"1" },{ "type": "white_noise", "audioFile": "waves","narration":"White - Waves" },{ "type": "white_noise", "audioFile": "fan","narration":"White - Fan" },{ "type": "international_clock", "city": "Kyoto" },{ "type": "countdown", "narration":"Coffee", "seconds":"240"},{ "type": "countdown", "narration":"Coffee", "seconds":"240"},{ "type": "countdown", "narration":"Timer", "seconds":"300"}] }';

  User() {
    log.debug("User | Constructor", "Starting Constructor");
    readUserData();
  }

  Future<bool> saveUserData() async {
    String logPrefix = "User | saveUserData";
    log.info(logPrefix, "Starting saveUserData function");

    //Check if this is a browser, in which case we will not save file data
    log.debug(logPrefix, "Checking if this is a browser: " + kIsWeb.toString());
    if (!kIsWeb) {
      log.debug(logPrefix, "This not a browser. Proceeding to save the file: ");
      final directory = await getApplicationSupportDirectory();
      String path = directory.path;
      final file = await File('$path/userprofile.txt');
      String stringData = json.encode(data);
      // Write the file
      file.writeAsString(stringData);
    } else {
      log.debug(logPrefix, "This is a browser. file will NOT be saved.");
    }
    return true;
  }

  Future<int> readUserData() async {
    String logPrefix = "User | readUserData";
    String contents = "0";

    try {
      if (!kIsWeb) {
        log.debug(logPrefix, "This is not a browser. Proceeding to read file Data.");
        final directory = await getApplicationSupportDirectory();
        String path = directory.path;
        //final file = await File('$path/userprofile.txt');

        // Read the file
        //final contents = "{'name':'Boss'}";

        //contents = await file.readAsString();
        contents = testContent;
        data = json.decode(contents.trim());
        log.debug(logPrefix, "Test, name is " + data?['name']);
      } else {
        log.debug(logPrefix, "This is a browser. Proceeding to load test data.");
        contents = testContent;
        data = json.decode(contents.trim());
      }

      return int.parse(contents);
    } catch (e) {
      log.error(logPrefix, e.toString());
      // If encountering an error, return 0
      return 0;
    }
  }
}
