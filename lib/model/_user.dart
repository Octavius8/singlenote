import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class User {
  Future<bool> saveUserData() async {
    final directory = await getApplicationSupportDirectory();
    String path = directory.path;
    final file = await File('$path/userprofile.txt');
    String data = "Hey hey";
    // Write the file
    file.writeAsString(data);
    return true;
  }
}
