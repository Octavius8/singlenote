import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../utils/_config.dart';
import '../utils/_log.dart';

class Note {
  String errorMessage = "", noteTags = "", noteTitle = "", noteContent = "", noteID = "";

  Log log = new Log();

  Note(String _noteID) {
    noteTags = "";
    noteTitle = "";
    noteContent = "";
    noteID = _noteID;
  }

  Future<String> getNote() async {
    String logPrefix = "Note | getNote()";
    log.info(logPrefix, "Starting getNote() function...");
    String finalString = "";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    try {
      String payload = jsonEncode(<String, String>{
        'method': "getNote",
        'note_id': noteID,
        'user_id': Config.OVI_USER_ID
      });

      log.debug(logPrefix, "URL: " + Config.OVI_API_URL);
      log.debug(logPrefix, "Payload being sent: $payload");

      var response = await http.post(
        Uri.parse(Config.OVI_API_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: payload,
      );

      log.debug(logPrefix, "Response: ${response.body}");
      Map<String, dynamic> jsontemp = jsonDecode(response.body);

      this.noteTags = jsontemp["data"]["note_tags"];
      this.noteTitle = jsontemp["data"]["note_title"];
      this.noteContent = jsontemp["data"]["note_content"];
      finalString = this.noteContent;
      errorMessage = formattedDate + "-" + response.statusCode.toString();
    } catch (ex) {
      log.error(logPrefix, formattedDate + "-" + ex.toString());
    }

    return finalString;
  }

  Future<bool> saveNote(String text) async {
    String logPrefix = "Note | saveNote()";
    log.info(logPrefix, "Starting saveNote() function...");
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
          'note_id': noteID,
          'user_id': Config.OVI_USER_ID,
          'note_title': this.noteTitle,
          'note_tags': this.noteTags,
          'note_content': text,
        }),
      );

      String payload = jsonEncode(<String, String>{
        'method': "getNote",
        'note_id': noteID,
        'user_id': Config.OVI_USER_ID
      });
      log.info(logPrefix, "Payload sent: $payload");
      log.info(logPrefix, "Response: ${response.body}");

      Map<String, dynamic> jsontemp = jsonDecode(response.body);
      if (response.statusCode == 200) finalString = true;
      errorMessage = formattedDate + "-" + response.body + response.statusCode.toString();
    } catch (ex) {
      this.errorMessage = formattedDate + "-" + ex.toString();
    }

    return finalString;
  }
}
