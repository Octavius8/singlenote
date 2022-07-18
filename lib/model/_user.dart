import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../utils/_log.dart';

class User {
  Log log = new Log();
  Map<String, dynamic>? data;
  //String testContent = '{ "name": "Boss","password":"d93591bdf7860e1e4ee2fca799911215","color_highlight":"62d9b5","primaryWidgets": [{"type": "international_clock", "city": "Lusaka" },{ "type": "countdown", "narration":"Coffee", "seconds":"10","voicePrompt":"true"},{ "type": "countdown", "narration":"Coffee", "seconds":"240"},{ "type": "countdown", "narration":"Timer", "seconds":"300"}]}';
  String testContent =
      '{"name": "Boss","password":"d93591bdf7860e1e4ee2fca799911215", "color_highlight": "62d9b5", "note":"", "Journal":"", "primaryWidgets": [{ "type": "international_clock", "city": "Lusaka" }, { "type": "international_clock", "city": "Mumbai" }, { "type": "white_noise", "audioFile": "ship", "narration": "White Noise" }, { "type": "countdown", "narration": "Coffee", "seconds": "300","voicePrompt":"false"}, { "type": "international_clock", "city": "Kyoto" }, { "type": "white_noise", "audioFile": "forest", "narration": "Observatory" }] }';
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
        log.debug(
            logPrefix, "This is not a browser. Proceeding to read file Data.");
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
        log.debug(
            logPrefix, "This is a browser. Proceeding to load test data.");
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
