/*
 * @author: John Lusumpa
 * @date: 25 May 2022
 *
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'utils/_log.dart';
import 'model/_note.dart';
import 'model/_user.dart';
import 'components/_primaryWidgetArea.dart';
import 'utils/_config.dart';
import 'components/_noteTextArea.dart';

//widgets

void main() async {
  /*WidgetsFlutterBinding.ensureInitialized();

  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Stateful Clicker Counter',
      theme: ThemeData(
        // Application theme data, you can set the colors for the application as
        // you want
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Clicker Counter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  Log log = new Log();
  //LockedScreen
  bool _lockedScreen = true;

  //Menu
  int _menuIndex = 0;

  //Note
  TextEditingController _noteTextController = new TextEditingController();
  TextEditingController _journalTextController = new TextEditingController();
  late final AnimationController _animationController;
  Note note = new Note(Config.OVI_NOTE_ID);
  String noteString = "";
  bool _anistart = true;
  bool _noteEditMode = false;
  User user = new User();
  //authentication

  //App Wide

  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.duration = Duration(milliseconds: 2000);
    _animationController.reset();
    _animationController.forward();
    setNote(Config.OVI_NOTE_ID);
    setNoteString();
  }

  void setNote(note_id) {
    note.noteID = note_id;
    setState(() {});
  }

  void setNoteString() async {
    noteString = await note.getNote();
    _noteTextController.text = noteString; // + "\nLog:\n" + log.logString;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void toast(String message) {
    Log log = new Log();
    try {
      Scaffold.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(seconds: 2)));
    } catch (ex) {
      log.error("Toast", "Toast Failed:" + ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  //Notepad
                  Positioned(
                      right: 10,
                      child: SingleChildScrollView(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            margin: EdgeInsets.only(top: 30),
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                            ),
                            width: MediaQuery.of(context).size.width - 50,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Row(
                                children: [
                                  //Widget Menu

                                  Icon(Icons.more_vert, color: Config.COLOR_LIGHTGRAY),
                                  //Primary Widget Area
                                  PrimaryWidgetArea(user: user),

                                  //Spacer
                                  Expanded(flex: 1, child: Text("")),

                                  //Reload
                                  GestureDetector(
                                      onTap: () async {
                                        if (_noteEditMode) {
                                          toast("Saving...");
                                          bool status = await note.saveNote(_noteTextController.text);
                                          if (status) {
                                            _noteEditMode = false;
                                            setState(() {});
                                          }
                                        } else {
                                          _noteEditMode = true;
                                          toast(Config.TOAST_NARRATION_EDITMODE);
                                          setState(() {});
                                        }
                                      },
                                      child: Icon(Icons.edit_note_rounded, color: _noteEditMode ? Config.COLOR_HIGHLIGHT : Config.COLOR_LIGHTGRAY, size: 32)),

                                  //Save Button
                                ],
                              ),

                              // Text Area
                              Stack(children: [
                                //Note Area
                                GestureDetector(
                                    onDoubleTap: () {
                                      _noteEditMode = true;
                                      toast(Config.TOAST_NARRATION_EDITMODE);
                                      setState(() {});
                                    },
                                    child: NoteTextArea(textController: _noteTextController, editMode: _noteEditMode))
                              ])
                            ])),
                      )),

                  //Side Menu

                  Column(children: [
                    SideMenu(items: [
                      "NOTE",
                      "JOURNAL",
                      "TRACKERS",
                      "TOOLKIT"
                    ], index: _menuIndex)
                  ]),

                  //Fingerprint Scanner
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    width: _lockedScreen ? MediaQuery.of(context).size.width : 40,
                    height: _lockedScreen ? MediaQuery.of(context).size.height : 40,
                    bottom: _lockedScreen ? 0 : 50,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (!_lockedScreen) _lockedScreen = true;
                        setState(() {});
                      },
                      child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            false ? Text("NOTE | 29", style: TextStyle(fontSize: 32, color: Color(0xFF888888))) : SizedBox.shrink(),
                            //Text(_authorized),
                            GestureDetector(
                                onTap: () {
                                  //_authenticateWithBiometrics();
                                  if (_lockedScreen)
                                    _lockedScreen = false;
                                  else
                                    _lockedScreen = true;
                                  setState(() {});
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  margin: false ? EdgeInsets.all(30) : EdgeInsets.only(right: 5),
                                  padding: _lockedScreen ? EdgeInsets.all(30) : EdgeInsets.all(2),
                                  child: AnimatedSize(
                                      duration: Duration(milliseconds: 600),
                                      child: Icon(
                                        Icons.lock,
                                        color: _lockedScreen ? Color(0xFF888888) : Colors.white,
                                        size: _lockedScreen ? 48 : 12,
                                      )),
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xFF888888))),
                                  //: Lottie.asset('assets/fingerprint.json'),
                                ))
                          ]),
                          decoration: BoxDecoration(color: _lockedScreen ? Color(0xFFffffff) : Color(0xFF242728), borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)))),
                    ),
                    //End of Container
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//Side Menu
  Widget SideMenu({items, index = 0}) {
    List<String> itemList = items;
    List<Widget> menuItems = [];
    double menuHeight = 500;
    double identifierLocation = (((index + 1) * (menuHeight / itemList.length.round()).toDouble()) - ((menuHeight / itemList.length.round()).toDouble()) / 2) - (index * 20);

    itemList.asMap().forEach((itemIndex, itemName) {
      menuItems.add(Container(
          padding: EdgeInsets.only(right: 5),
          height: (menuHeight / itemList.length.round()).toDouble() - 10,
          width: 40,
          child: Align(
              alignment: Alignment.center,
              child: RotatedBox(
                  quarterTurns: -1,
                  child: GestureDetector(
                      onTap: () {
                        String logPrefix = "SideMenu | onTap()";
                        String noteID = "";

                        if (itemIndex == Config.MENU_NOTEINDEX) noteID = Config.OVI_NOTE_ID;
                        if (itemIndex == Config.MENU_JOURNALINDEX) noteID = Config.OVI_JOURNAL_ID;
                        if (itemIndex == Config.MENU_SHORTCUTSINDEX) noteID = Config.OVI_SHORTCUTS_ID;

                        log.info(logPrefix, "_menuIndex=$_menuIndex, noteID=$noteID");
                        setNote(noteID);
                        setNoteString();

                        _noteEditMode = false;
                        _menuIndex = itemIndex;
                        setState(() {});
                      },
                      child: Text(
                        itemName,
                        style: TextStyle(fontSize: 12, color: itemIndex == index ? Colors.white : Color(0xFFbbbbbb)),
                      ))))));
    });

    return Container(
      child: Stack(children: [
        Container(decoration: BoxDecoration(color: Color(0xFF242728), borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))), child: Column(children: menuItems)),
        //Selector
        AnimatedPositioned(
            top: identifierLocation,
            left: 35,
            duration: Duration(milliseconds: 500),
            child: Transform.rotate(
                angle: -math.pi / 4,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(color: Color(0xFFfafafa), borderRadius: BorderRadius.circular(5)),

                  //Tiny dot
                )))
      ]),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
