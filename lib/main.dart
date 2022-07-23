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
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert' show utf8;
import 'package:url_launcher/url_launcher.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  Log log = new Log();
  //LockedScreen
  bool _lockedScreen = true;
  bool _displaySettings = false;

  //Menu
  int _menuIndex = 0;

  //Note
  TextEditingController _noteTextController = new TextEditingController();
  TextEditingController _journalTextController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late final AnimationController _animationController;
  Note note = new Note(Config.OVI_NOTE_ID);
  String noteString = "";
  bool _anistart = true;
  bool _noteEditMode = false;
  User user = new User();
  bool correctPassword = true;
  UserWidgetsModel? userWidgetsModel;
  //authentication

  //App Wide

  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.duration = Duration(milliseconds: 2000);
    _animationController.reset();
    _animationController.forward();
    setNote(Config.OVI_NOTE_ID);
    userWidgetsModel = new UserWidgetsModel(user: this.user);
    setNoteString();
  }

  String getMd5(String input) {
    var md5 = crypto.md5;
    return md5.convert(utf8.encode(input)).toString();
  }

  bool validatePassword() {
    log.debug("Pass", "Started validation function ");
    String password = _passwordController.text;
    if (getMd5(password) == user.data?['password']) {
      log.debug(
          "Pass",
          "Correct password. Password entered is " +
              getMd5(password) +
              " instead of" +
              user.data?['password']);
      return true;
    }
    log.debug(
        "Pass",
        "Wrong password. Password entered is " +
            getMd5(password) +
            " instead of" +
            user.data?['password']);
    return false;
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), duration: Duration(seconds: 2)));
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
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      //Widget Menu
                                      GestureDetector(
                                          onTap: () {
                                            _displaySettings = true;
                                            setState(() {});
                                          },
                                          child: Icon(Icons.more_vert,
                                              color: Config.COLOR_LIGHTGRAY)),
                                      //Primary Widget Area
                                      PrimaryWidgetArea(user: user),

                                      //Spacer
                                      Expanded(flex: 1, child: Text("")),

                                      //Save
                                      GestureDetector(
                                          onTap: () async {
                                            if (_noteEditMode) {
                                              toast("Saving...");
                                              bool status = await note.saveNote(
                                                  _noteTextController.text);
                                              if (status) {
                                                _noteEditMode = false;
                                                setState(() {});
                                              }
                                            } else {
                                              _noteEditMode = true;
                                              toast(Config
                                                  .TOAST_NARRATION_EDITMODE);
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(
                                              _noteEditMode
                                                  ? Icons.save_as
                                                  : Icons.edit_note_rounded,
                                              color: _noteEditMode
                                                  ? Config.COLOR_LIGHTGRAY
                                                  : null,
                                              size: _noteEditMode ? 30 : 32)),

                                      //Save Button
                                    ],
                                  ),

                                  // Text Area
                                  Stack(children: [
                                    //Note Area
                                    GestureDetector(
                                        onDoubleTap: () {
                                          _noteEditMode = true;
                                          toast(
                                              Config.TOAST_NARRATION_EDITMODE);
                                          setState(() {});
                                        },
                                        child: NoteTextArea(
                                            textController: _noteTextController,
                                            editMode: _noteEditMode))
                                  ])
                                ])),
                      )),

                  //Settings
                  //Black screen
                  Positioned(
                      //duration: Duration(milliseconds: 300),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      top: _displaySettings
                          ? 0
                          : -(MediaQuery.of(context).size.height),
                      child: GestureDetector(
                          onTap: () {
                            _displaySettings = false;
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Color(0x77000000)),
                            child: Text("Hey Nigger.."),
                          ))),

                  //Settings Menu
                  AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width -
                          (MediaQuery.of(context).size.width / 3),
                      left: _displaySettings
                          ? 0
                          : -MediaQuery.of(context).size.width -
                              (MediaQuery.of(context).size.width / 3),
                      child: Container(
                        margin: EdgeInsets.only(left: Config.MENU_WIDTH),
                        padding: EdgeInsets.only(
                            left: Config.PADDING_DEFAULT,
                            right: Config.PADDING_DEFAULT,
                            top: 30),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(children: [
                          Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text("Your Widgets")),
                          Wrap(
                              spacing: 5,
                              children:
                                  userWidgetsModel!.compileListOfWidgets()),
                        ]),
                      )),

                  //Side Menu

                  Column(children: [
                    SideMenu(
                        items: ["NOTE", "JOURNAL", "SCROLL II", "ASSISTANT"],
                        index: _menuIndex)
                  ]),

                  //Fingerprint Scanner
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    width: _lockedScreen
                        ? MediaQuery.of(context).size.width
                        : Config.MENU_WIDTH,
                    height: _lockedScreen
                        ? MediaQuery.of(context).size.height
                        : Config.MENU_WIDTH,
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // _lockedScreen ? Text("NOTE | 29", style: TextStyle(fontSize: 32, color: Config.COLOR_DARKGRAY)) : SizedBox.shrink(),

                                //Password
                                _lockedScreen
                                    ? Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: SizedBox(
                                            width: 130,
                                            child: TextField(
                                                cursorColor: correctPassword
                                                    ? Config.COLOR_DARKGRAY
                                                    : Colors.red,
                                                controller: _passwordController,
                                                maxLength: 4,
                                                obscureText: true,
                                                autocorrect: false,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: correctPassword
                                                        ? Config.COLOR_DARKGRAY
                                                        : Colors.red,
                                                    letterSpacing: 14),
                                                decoration: InputDecoration(
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: correctPassword
                                                              ? Config
                                                                  .COLOR_DARKGRAY
                                                              : Colors.red),
                                                    ),
                                                    /*hintText: "****", hintStyle: TextStyle(color: Colors.white),*/ counterText:
                                                        "" /*, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Config.COLOR_DARKGRAY))*/,
                                                    fillColor: Colors.white,
                                                    filled: true))))
                                    : SizedBox.shrink(),

                                //Text(_authorized),
                                GestureDetector(
                                    onTap: () {
                                      //_authenticateWithBiometrics();
                                      if (_lockedScreen) {
                                        if (validatePassword()) {
                                          _lockedScreen = false;
                                          _passwordController.text = "";
                                          correctPassword = true;
                                        } else {
                                          //Incorrect password
                                          correctPassword = false;
                                        }
                                      } else
                                        _lockedScreen = true;
                                      setState(() {});
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      margin: false
                                          ? EdgeInsets.all(30)
                                          : EdgeInsets.only(right: 5),
                                      padding: _lockedScreen
                                          ? EdgeInsets.all(30)
                                          : EdgeInsets.all(2),
                                      child: AnimatedSize(
                                          duration: Duration(milliseconds: 600),
                                          child: Icon(
                                            Icons.lock,
                                            color: _lockedScreen
                                                ? correctPassword
                                                    ? Config.COLOR_DARKGRAY
                                                    : Colors.red
                                                : Colors.white,
                                            size: _lockedScreen ? 48 : 12,
                                          )),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: correctPassword
                                                  ? Config.COLOR_DARKGRAY
                                                  : Colors.red)),
                                      //: Lottie.asset('assets/fingerprint.json'),
                                    ))
                              ]),
                          decoration: BoxDecoration(
                              color: _lockedScreen
                                  ? Color(0xFFffffff)
                                  : Color(0xFF242728),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)))),
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
    double identifierLocation =
        (((index + 1) * (menuHeight / itemList.length.round()).toDouble()) -
                ((menuHeight / itemList.length.round()).toDouble()) / 2) -
            (index * 20);

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

                        if (itemIndex == Config.MENU_NOTEINDEX)
                          noteID = Config.OVI_NOTE_ID;
                        if (itemIndex == Config.MENU_JOURNALINDEX)
                          noteID = Config.OVI_JOURNAL_ID;
                        if (itemIndex == Config.MENU_SHORTCUTSINDEX)
                          noteID = Config.OVI_SHORTCUTS_ID;

                        log.info(logPrefix,
                            "_menuIndex=$_menuIndex, noteID=$noteID");
                        setNote(noteID);
                        setNoteString();

                        _noteEditMode = false;
                        _menuIndex = itemIndex;
                        setState(() {});
                      },
                      child: Text(
                        itemName,
                        style: TextStyle(
                            fontSize: 12,
                            color: itemIndex == index
                                ? Colors.white
                                : Color(0xFFbbbbbb)),
                      ))))));
    });

    return Container(
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              decoration: BoxDecoration(
                  color: Color(0xFF242728),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(30))),
              child: Column(children: menuItems)),

          //Assistant
        ]),
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
                  decoration: BoxDecoration(
                      color: Color(0xFFfafafa),
                      borderRadius: BorderRadius.circular(5)),

                  //Tiny dot
                )))
      ]),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
