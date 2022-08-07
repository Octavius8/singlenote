import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/_log.dart';
import '_note.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class UserData {
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
      return contents.toString();
    } catch (e) {
      // If encountering an error, return 0
      log.info("UserData", "Failed to open file: ${e.toString()}");
      log.info("UserData",
          "Creating new data file. Copying data from data_template");
      data =
          json.decode(await rootBundle.loadString('assets/data_template.json'));
      saveData();
      log.info("UserData", "New Data File created successfully");
      return "0";
    }
  }

  List<Note> getAllNotes() {
    List<Note> finalList = [];
    data?["notes"].forEach((note) {
      finalList.add(getNote(note["noteId"]));
    });

    return finalList;
  }

  Note getNote(int note_id) {
    String noteTags = data?["notes"][note_id.toString]["noteTags"];
    String noteTitle = data?["notes"][note_id.toString]["noteTitle"];
    String noteContent = data?["notes"][note_id.toString]["noteContent"];
    String noteID = note_id.toString();
    Note note = new Note(
        noteID: noteID,
        noteTags: noteTags,
        noteTitle: noteTitle,
        noteContent: noteContent);
    return note;
  }

  bool saveNote(Note? note) {
    bool status = false;

    return status;
  }

  void saveData() async {
    bool status = false;
    String str = json.encode(data);
    final file = await _localFile;
    file.writeAsString(str);
  }
}
