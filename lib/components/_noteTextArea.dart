import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

class NoteTextArea extends StatefulWidget {
  TextEditingController textController;
  NoteTextArea({required this.textController});
  @override
  State<StatefulWidget> createState() {
    return new NoteTextAreaState();
  }
}

class NoteTextAreaState extends State<NoteTextArea> {
  bool _keyboardVisible = false;
  late StreamSubscription<bool> keyboardSubscription;
  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisible = keyboardVisibilityController.isVisible;
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      _keyboardVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            height: _keyboardVisible
                ? 400
                : MediaQuery.of(context).size.height - 100,
            child: TextField(
              maxLines: null,
              minLines: 60,
              style: TextStyle(fontSize: 13),
              keyboardType: TextInputType.multiline,
              controller: widget.textController,
            )));
  }
}
