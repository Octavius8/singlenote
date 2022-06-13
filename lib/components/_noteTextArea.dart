import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';
import '../_config.dart';
import '../model/_log.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class NoteTextArea extends StatefulWidget {
  TextEditingController textController;
  bool editMode;

  NoteTextArea({required this.textController, this.editMode = false});
  @override
  State<StatefulWidget> createState() {
    return new NoteTextAreaState();
  }
}

class NoteTextAreaState extends State<NoteTextArea> {
  bool _keyboardVisible = false;
  late StreamSubscription<bool> keyboardSubscription;
  Log log = new Log();

  //Copy/Upload Popup
  double _copyPopupX = 0;
  double _copyPopupY = 0;
  String _copyString = "";
  bool _copyPopupVisible = false;

  void showCopyPopup(TapDownDetails details) {
    log.info("NoteTextArea | showCopyPopup()", "Initial (Raw) Y value=" + details.globalPosition.dy.toString() + " | X value=" + details.globalPosition.dx.toString());
    _copyPopupX = details.globalPosition.dx - 40;
    _copyPopupY = details.globalPosition.dy - 110;
    _copyPopupVisible = true;
    if (_copyPopupY < 0) _copyPopupY = (_copyPopupY * -1) - 16;
    if (_copyPopupX > MediaQuery.of(context).size.width - 175) _copyPopupX = MediaQuery.of(context).size.width - 175;
    log.info("NoteTextArea | showCopyPopup()", "Y value=" + _copyPopupY.toString() + " | X value=" + _copyPopupX.toString());

    setState(() {});
  }

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisible = keyboardVisibilityController.isVisible;
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      _keyboardVisible = visible;
    });
  }

  void closePopups() {
    _copyPopupVisible = false;
    setState(() {});
  }

  void toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      //View Screen
      !widget.editMode
          ?
          //Viewing Screen
          Container(width: double.infinity, padding: EdgeInsets.only(top: 10, left: 10, right: 10), height: MediaQuery.of(context).size.height - 100, child: SingleChildScrollView(child: RichText(text: TextSpan(style: TextStyle(color: Config.COLOR_PRIMARY), children: stringToTextSpanList(widget.textController.text)))))
          :

          //Editing Screen
          SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  height: _keyboardVisible ? 400 : MediaQuery.of(context).size.height - 100,
                  child: TextField(
                    maxLines: null,
                    minLines: 60,
                    style: TextStyle(fontSize: 13),
                    keyboardType: TextInputType.multiline,
                    controller: widget.textController,
                  ))),

      //Link Copy vs Launch

      _copyPopupVisible && !widget.editMode
          ? Positioned(
              left: _copyPopupX,
              top: _copyPopupY,
              child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    //rborder: Border.all(color: Config.COLOR_LIGHTGRAY),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(5),
                  child: Row(children: [
                    Expanded(
                        child: Container(
                            child: GestureDetector(
                                onTap: () {
                                  _launchUrl(_copyString);
                                  closePopups();
                                  toast("Openning ...");
                                },
                                child: Icon(Icons.open_in_browser, size: 18, color: Config.COLOR_LIGHTGRAY)))),
                    Expanded(
                        child: Container(
                            child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: _copyString));
                                  closePopups();
                                  toast("Copied to Clipboard ... ");
                                },
                                child: Icon(Icons.copy, size: 18, color: Config.COLOR_LIGHTGRAY)))),
                    Expanded(
                        child: Container(
                            child: GestureDetector(
                                onTap: () {
                                  closePopups();
                                },
                                child: Icon(Icons.close, size: 18, color: Config.COLOR_LIGHTGRAY))))
                  ])))
          : SizedBox.shrink(),
    ]);
  }

  List<TextSpan> stringToTextSpanList(String originalText) {
    List<TextSpan> finalList = [];
    //Split string into individual words
    List<String> individualWords = originalText.split(' ');

    //Loop process each word
    individualWords.forEach((String word) {
      //Default
      TextSpan finalTextSpan = TextSpan(text: word + " ");

      //Check if its a website
      if (isWebsite(word)) finalTextSpan = getWebsiteTextSpan(word);

      finalList.add(finalTextSpan);
    });
    return finalList;
  }

  //Website Processing
  bool isWebsite(String word) {
    String logPrefix = "NoteTextArea | isWebsite()";
    /*final websiteCheck = RegExp(
        r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$');*/
    final websiteCheck = RegExp(r'(^(http[s]?:\/{2})|(^www))(\S*|.*)');
    log.debug(logPrefix, "word is: $word. isWebsite response is " + websiteCheck.hasMatch(word).toString());
    return websiteCheck.hasMatch(word);
  }

  TextSpan getWebsiteTextSpan(String word) {
    return TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTapDown = (TapDownDetails details) {
            _copyString = word;
            showCopyPopup(details);
          },
        text: word + " ",
        style: TextStyle(fontWeight: FontWeight.bold, color: Config.COLOR_HYPERLINK));
  }

  void _launchUrl(String _url) async {
    Uri url = Uri.parse(_url);
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }
}
