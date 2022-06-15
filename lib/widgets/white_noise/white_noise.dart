import 'package:flutter/material.dart';
import '../../_config.dart';
import '../../model/_log.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class WhiteNoise extends StatefulWidget {
  String narration;
  String audioFile;

  //Constructor
  WhiteNoise({this.audioFile = "", this.narration = "White Noise"});

  @override
  WhiteNoiseState createState() => WhiteNoiseState();
}

// NOTE: If you look at the source code for this app, you'll notice that
// all animation related code is omitted here. I will be added in as the lesson
// progresses.

class WhiteNoiseState extends State<WhiteNoise> {
  final player = AudioPlayer();
  String audioFilePath = "";
  Log log = new Log();

  @override
  void initState() {
    super.initState();
    setAudioWeb();
  }

  void setAudio() async {
    String logPrefix = "WhiteNoise | setAudio";

    audioFilePath = "assets/widgets/white_noise/${widget.audioFile}.mp3";
    log.debug(logPrefix, "audioFilePath: $audioFilePath");

    var duration = await player.setAsset(audioFilePath);
    await player.setLoopMode(LoopMode.one);
  }

  void setAudioWeb() async {
    String logPrefix = "WhiteNoise | setAudio";
    audioFilePath = "https://www.ovidware.com/random/${widget.audioFile}.mp3";
    log.debug(logPrefix, "audioFilePath: $audioFilePath");

    var duration = await player.setUrl(audioFilePath);
    await player.setLoopMode(LoopMode.one);
  }

  void toggleState() async {
    String logPrefix = "WhiteNoise | toggleState";
    log.info(logPrefix, "Entered toggle state function. Current Playing State:${player.playing.toString()}");

    if (player.playing) {
      log.debug(logPrefix, "Attempting to Stop the player...");
      try {
        await player.stop();
      } catch (ex) {
        log.error(logPrefix, ex.toString());
      }
      log.debug(logPrefix, "Completed player.stop function & Changed status of playing to false.");
    } else {
      log.debug(logPrefix, "Attempting to Start the player...");
      try {
        await player.play();
      } catch (ex) {
        log.error(logPrefix, ex.toString());
      }

      log.debug(logPrefix, "Completed player.start function & Changed status of playing to true.");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          toggleState();
        },
        child: Container(
            width: Config.WIDGET_WIDTH,
            height: Config.WIDGET_HEIGHT,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Expanded(flex: 2, child: Icon(Icons.multitrack_audio_outlined, size: 14, color: player.playing ? Config.COLOR_HIGHLIGHT : null)),
              Expanded(child: Text(widget.narration, style: TextStyle(fontSize: Config.WIDGET_FONTSIZE, color: player.playing ? Config.COLOR_HIGHLIGHT : null)))
            ])));
  }
}

class AudioFile {
  static final int fan = 0;
  static final int waves = 1;
}
