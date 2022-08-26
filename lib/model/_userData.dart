import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/_log.dart';
import '../utils/_config.dart';
import '../model/_userWidget.dart';
import '_note.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class UserDataFactory {
  Future<UserData> initUserData() async {
    UserData userData = new UserData();
    var temp = await userData.loadData();
    return userData;
  }
}

class UserData with ChangeNotifier {
  Map<String, dynamic>? data;
  Log log = new Log();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<bool> loadData() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      data = json.decode(contents.trim());
      log.info("UserData | loadData", "Data has been loaded successfully.");
      notifyListeners();
      return true;
    } catch (e) {
      // If encountering an error, return 0
      log.info("UserData", "Failed to open file: ${e.toString()}");
      createDataFile();
      loadData();
      return false;
    }
  }

  Future<String> createDataFile() async {
    log.info(
        "UserData", "Creating new data file. Copying data from data_template");
    data = json.decode(await rootBundle.loadString(Config.DATA_TEMPLATE_FILE));
    saveData();
    log.info("UserData", "New Data File created successfully");
    return "0";
  }

  void resetData() async {
    data =
        json.decode(await rootBundle.loadString('assets/data_template.json'));
    saveData();
  }

  List<Note> getAllNotes() {
    List<Note> finalList = [];
    try {
      List.castFrom(data?["notes"]).forEach((note) {
        Note? tempNote = getNote(int.parse(note["noteID"]));
        if (tempNote != null) {
          finalList.add(tempNote);
          log.debug("UserData | getAllNotes()", "New Note being added...");
        }
      });

      finalList.sort((a, b) => b.noteID.compareTo(a.noteID));
    } catch (e) {
      log.error("UserData | getAllNotes()", "Failure: ${e.toString()}");
    }
    return finalList;
  }

  Note? getNote(int note_id) {
    Note? note;
    try {
      List notesList = data?["notes"];
      Map tempMap = new Map();

      notesList.forEach((tempNote) {
        if (tempNote['noteID'] == note_id.toString()) {
          log.debug("UserData | getNote()",
              "data matching is " + tempNote.toString());
          tempMap = tempNote;
        }
      });
      String noteTags = tempMap["noteTags"];
      String noteTitle = tempMap["noteTitle"];
      String noteContent = tempMap["noteContent"];
      String noteID = note_id.toString();

      note = new Note(
          noteID: noteID,
          noteTags: noteTags,
          noteTitle: noteTitle,
          noteContent: noteContent);
    } catch (e) {
      log.error("UserData | getNote()", "Failure: ${e.toString()}");
    }
    return note;
  }

  bool saveNote(Note? note) {
    bool status = false;
    log.info("User | saveNote",
        "Started saveNote function. Note ID is ${note?.noteID}");
    try {
      List<Map<String, dynamic>> notesList = List.castFrom(data?["notes"]);
      notesList.removeWhere((item) => item['noteID'] == note!.noteID);
      notesList.add(note!.toMap());
      data?["notes"] = notesList;
      saveData();
      status = true;
    } catch (ex) {
      log.error("User | SaveNote", "Something went wrong: " + ex.toString());
    }
    return status;
  }

  Future<bool> newNote(Note note) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    note.noteID = timestamp.toString();
    List<Map<String, dynamic>> notesList = List.castFrom(data?["notes"]);
    notesList.add(note.toMap());
    data?["notes"] = notesList;
    saveData();
    return true;
  }

  List<UserWidget> getAllUserWidgets() {
    List<UserWidget> finalList = [];
    Color highlightColor = Color(
        int.parse("FF" + data?['mobileApp']['highlightColor'], radix: 16));

    try {
      List.castFrom(data?["mobileApp"]["primaryWidgets"]).forEach((widgetMap) {
        if (widgetMap != null) {
          log.debug("UserData | getAllUserWidgets()",
              "Processing " + widgetMap.toString());
          UserWidget userWidget = new UserWidget(
              type: widgetMap["type"],
              narration: widgetMap["narration"],
              options: Map.castFrom(widgetMap["options"]),
              highlightColor: highlightColor);

          finalList.add(userWidget);
          log.debug(
              "UserData | getAllUserWidgets()", "New Widget being added...");
        }
      });
      log.debug(
          "UserData | getAllUserWidgets()",
          "Finished loading widgets. Total widgets: " +
              finalList.length.toString());
      //finalList.sort((a, b) => b.noteID.compareTo(a.noteID));
    } catch (e) {
      log.error("UserData | getAllUserWidgets()", "Failure: ${e.toString()}");
    }
    return finalList;
  }

  String toString() {
    String str = json.encode(data);
    return str;
  }

  //Save Widget
  bool saveWidget(UserWidget? userWidget) {
    bool status = false;
    log.info("User | saveNote",
        "Started saveWidget function. Widget ID is ${userWidget?.widgetID}");
    try {
      List<Map<String, dynamic>> widgetList =
          List.castFrom(data?["mobileApp"]["primaryWidgets"]);
      widgetList
          .removeWhere((item) => item['widgetID'] == userWidget!.widgetID);
      widgetList.add(userWidget!.toMap());
      data?["mobileApp"]["primaryWidgets"] = widgetList;
      saveData();
      status = true;
    } catch (ex) {
      log.error("User | SaveWidget", "Something went wrong: " + ex.toString());
    }
    return status;
  }

  void saveData() async {
    bool status = false;
    String str = json.encode(data);
    log.info("UserNote | saveData() | ", str);
    final file = await _localFile;
    file.writeAsString(str);
    notifyListeners();
  }
}
