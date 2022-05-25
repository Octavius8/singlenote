import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '_config.dart';

class Note {
  String errorMessage = "", noteTags = "", noteTitle = "", noteContent = "";

  Note() {
    noteTags = "";
    noteTitle = "";
    noteContent = "";
  }

  Future<String> getNote() async {
    String finalString = "";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    try {
      var response = await http.post(
        Uri.parse(Config.OVI_API_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'method': "getNote",
          'note_id': Config.OVI_NOTE_ID,
          'user_id': Config.OVI_USER_ID
        }),
      );
      Map<String, dynamic> jsontemp = jsonDecode(response.body);
      this.noteTags = jsontemp["data"]["note_tags"];
      this.noteTitle = jsontemp["data"]["note_title"];
      this.noteContent = jsontemp["data"]["note_content"];
      finalString = this.noteContent;
      errorMessage = formattedDate + "-" + response.statusCode.toString();
    } catch (ex) {
      this.errorMessage = formattedDate + "-" + ex.toString();
    }

    return finalString;
  }

  Future<bool> saveNote(String text) async {
    bool finalString = false;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    try {
      var response = await http.post(
        Uri.parse(Config.OVI_API_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'method': "saveNote",
          'note_id': Config.OVI_NOTE_ID,
          'user_id': Config.OVI_USER_ID,
          'note_title': this.noteTitle,
          'note_tags': this.noteTags,
          'note_content': text,
        }),
      );
      Map<String, dynamic> jsontemp = jsonDecode(response.body);
      if (response.statusCode == 200) finalString = true;
      errorMessage =
          formattedDate + "-" + response.body + response.statusCode.toString();
    } catch (ex) {
      this.errorMessage = formattedDate + "-" + ex.toString();
    }

    return finalString;
  }
}
