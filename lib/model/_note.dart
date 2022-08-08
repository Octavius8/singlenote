import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../utils/_config.dart';

class Note {
  String noteTags, noteTitle, noteContent, noteID;

  Note(
      {required this.noteID,
      required this.noteContent,
      required this.noteTags,
      required this.noteTitle});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> finalMap = {
      "noteID": this.noteID,
      "noteContent": noteContent,
      "noteTags": noteTags,
      "noteTitle": noteTitle
    };

    return finalMap;
  }
}
