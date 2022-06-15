import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../model/_log.dart';

class User {
  Log log = new Log();
  Map<String, dynamic>? data;

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
    try {
      log.debug(logPrefix, "This is not a browser. Proceeding to read file Data.");
      final directory = await getApplicationSupportDirectory();
      String path = directory.path;
      final file = await File('$path/userprofile.txt');

      // Read the file
      final contents = "{'name':'Boss'}";
      //final contents = await file.readAsString();
      data = json.decode(contents.trim());

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
}
