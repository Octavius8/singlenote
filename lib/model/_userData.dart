import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/_log.dart';
import '_note.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../utils/_config.dart';

class UserData with ChangeNotifier {
  Map<String, dynamic>? data;
  Log log = new Log();

  UserData() {
    loadData();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<String> loadData() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      data = json.decode(contents.trim());
      notifyListeners();
      return contents.toString();
    } catch (e) {
      // If encountering an error, return 0
      log.info("UserData", "Failed to open file: ${e.toString()}");
      log.info("UserData",
          "Creating new data file. Copying data from data_template");
      data =
          json.decode(await rootBundle.loadString(Config.DATA_TEMPLATE_FILE));
      saveData();
      log.info("UserData", "New Data File created successfully");
      return "0";
    }
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

  void saveData() async {
    bool status = false;
    String str = json.encode(data);
    log.info("UserNote | saveData() | ", str);
    final file = await _localFile;
    file.writeAsString(str);
    notifyListeners();
  }
}
