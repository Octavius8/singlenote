import 'package:flutter/material.dart';
import '../utils/_config.dart';
import '../model/_note.dart';
import '../model/_userData.dart';
import '../utils/_log.dart';

class NoteList extends StatefulWidget {
  UserData user;
  BuildContext context;
  Function onSelect;

  NoteList(
      {Key? key,
      required this.user,
      required this.context,
      required this.onSelect})
      : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  Future<List<Widget>>? widgetsListNotes;
  TextEditingController _newNoteTitleController = new TextEditingController();
  Log log = new Log();

  @override
  void initState() {
    super.initState();
    widget.user.addListener(() {
      log.debug(
          "NoteList | initState()", "NoteList received notification of change");

      loadNotes();
    });
    loadNotes();
  }

  void loadNotes() async {
    widgetsListNotes = widgetListNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - (Config.MENU_WIDTH + 5),
      height: MediaQuery.of(context).size.height - 100,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
          color: Config.COLOR_PRIMARY,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0))),
      child: Column(children: [
        Row(children: [
          Expanded(child: SizedBox.shrink()),
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                  onTap: () {
                    showConfirmationResetDialog(this.context);
                  },
                  child: Icon(Icons.search,
                      color: Config.COLOR_LIGHTGRAY, size: 20))),
          GestureDetector(
              onTap: () {
                _displayNewNoteDialog(widget.context);
              },
              child: Icon(Icons.add, color: Config.COLOR_LIGHTGRAY, size: 20)),
        ]),
        FutureBuilder<List<Widget>>(
            future: widgetsListNotes,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Widget>> snapshot,
            ) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Container(
                    height: MediaQuery.of(context).size.height - 140,
                    child: SingleChildScrollView(
                        child: Column(children: snapshot.data ?? [])));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(color: Colors.white))
                    ]);
              }
              return Text("");
            })
      ]),
    );
  }

  //Notes List Widget
  Future<List<Widget>> widgetListNotes() async {
    //await Future.delayed(const Duration(seconds: 5), () {});

    List<Widget> finalList = [];
    log.debug("NoteList | widgetListNotes()", "Getting all notes...");
    List<Note> notesList = widget.user.getAllNotes();
    log.debug("NoteList | widgetListNotes()",
        "Total notes received ${notesList.length.toString()}");

    try {
      notesList.forEach((note) {
        String content = note.noteContent;
        if (content.length > 80)
          content = content.substring(0, 80).toString() + " ...";
        finalList.add(GestureDetector(
            onTap: () {
              widget.onSelect(int.parse(note.noteID));
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              height: 100,
              padding: EdgeInsets.all(10),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Config.COLOR_PRIMARY,
                  border: Border.all(
                    color: Config.COLOR_LIGHTGRAY,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: Wrap(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(note.noteTitle, style: TextStyle(color: Colors.white)),
                  Text(content, style: TextStyle(color: Config.COLOR_LIGHTGRAY))
                ])
              ]),
            )));
      });
    } catch (e) {
      log.error("NoteList | widgetListNotes()", "Failure: ${e.toString()}");
    }

    log.debug("NoteList | widgetListNotes()",
        "finalList count is ${finalList.length.toString()}");
    return finalList;
  }

  Future<void> _displayNewNoteDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Note Name'),
            content: TextField(
              onChanged: (value) {},
              controller: _newNoteTitleController,
              decoration: InputDecoration(hintText: ""),
            ),
            actions: <Widget>[
              FlatButton(
                color: Config.COLOR_PRIMARY,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Note newNote = new Note(
                        noteID: "",
                        noteTitle: _newNoteTitleController.text,
                        noteContent: "",
                        noteTags: "");
                    widget.user.newNote(newNote);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void showConfirmationResetDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        widget.user.resetData();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset Data"),
      content:
          Text("Would you like to continue resetting the current user data?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
