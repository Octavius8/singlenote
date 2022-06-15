import 'package:flutter/material.dart';
import '../../_config.dart';
import '../../model/_log.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class WhiteNoise extends StatefulWidget {
  String narration = "White Noise";
  int audioFile;

  //Constructor
  WhiteNoise({this.audioFile = 0});

  @override
  WhiteNoiseState createState() => WhiteNoiseState();
}

// NOTE: If you look at the source code for this app, you'll notice that
// all animation related code is omitted here. I will be added in as the lesson
// progresses.

class WhiteNoiseState extends State<WhiteNoise> {
  final player = AudioPlayer();
  String audioFilePath = "";
  bool playing = false;
  Log log = new Log();

  @override
  void initState() {
    super.initState();
    setAudioWeb();
  }

  void setAudio() async {
    String logPrefix = "WhiteNoise | setAudio";
    //if(widget.audioFile==audioFile.fan)
    audioFilePath = "assets/widgets/white_noise/fan.mp3";
    if (widget.audioFile == AudioFile.waves) audioFilePath = "widgets/white_noise/waves.mp3";
    log.debug(logPrefix, "audioFilePath: $audioFilePath");

    var duration = await player.setAsset(audioFilePath);
    await player.setLoopMode(LoopMode.one);
  }

  void setAudioWeb() async {
    String logPrefix = "WhiteNoise | setAudio";
    //if(widget.audioFile==audioFile.fan)
    audioFilePath = "https://www.ovidware.com/random/fan.mp3";
    if (widget.audioFile == AudioFile.waves) audioFilePath = "https://www.ovidware.com/random/waves.mp3";
    log.debug(logPrefix, "audioFilePath: $audioFilePath");

    var duration = await player.setUrl(audioFilePath);
    await player.setLoopMode(LoopMode.one);
  }

  void toggleState() async {
    String logPrefix = "WhiteNoise | toggleState";
    log.info(logPrefix, "Entered toggle state function. Current Playing State:${playing.toString()}");

    player.playerStateStream.listen((state) async {
      if (state.playing) {
        log.debug(logPrefix, "Attempting to Stop the player...");
        playing = false;
        try {
          await player.stop();
        } catch (ex) {
          log.error(logPrefix, ex.toString());
        }
        log.debug(logPrefix, "Completed player.stop function & Changed status of playing to false.");
      } else {
        log.debug(logPrefix, "Attempting to Start the player...");
        playing = true;
        try {
          await player.play();
        } catch (ex) {
          log.error(logPrefix, ex.toString());
        }
        playing = true;
        log.debug(logPrefix, "Completed player.start function & Changed status of playing to true.");
      }
    });

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
              Expanded(flex: 2, child: Icon(Icons.multitrack_audio_outlined, size: 14, color: playing ? Config.COLOR_HIGHLIGHT : null)),
              Expanded(child: Text(widget.narration, style: TextStyle(fontSize: Config.WIDGET_FONTSIZE, color: playing ? Config.COLOR_HIGHLIGHT : null)))
            ])));
  }
}

class AudioFile {
  static final int fan = 0;
  static final int waves = 1;
}
