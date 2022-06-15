import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../model/_log.dart';

class User {
  Future<bool> saveUserData() async {
    String logPrefix = "User | saveUserData";
    Log log = new Log();
    log.debug(logPrefix, "Checking if this is a browser: " + kIsWeb.toString());
    if (!kIsWeb) {
      final directory = await getApplicationSupportDirectory();
      String path = directory.path;
      final file = await File('$path/userprofile.txt');
      String data = "Hey hey";
      // Write the file
      file.writeAsString(data);
    }
    return true;
  }
}
