import 'dart:io';

import 'package:audio_recorder/dimensions.dart';
import 'package:audio_recorder/providers/play_audio_provider.dart';
import 'package:audio_recorder/providers/record_audio_provider.dart';
import 'package:audio_recorder/screens/audio_recordings.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class RecordAndPlayScreen extends StatefulWidget {
  const RecordAndPlayScreen({super.key});

  @override
  State<RecordAndPlayScreen> createState() => _RecordAndPlayScreenState();
}

class _RecordAndPlayScreenState extends State<RecordAndPlayScreen> {
  List<FileSystemEntity> _folders = [];

  @override
  void initState() {
    super.initState();
    getDir();
  }

  @override
  Widget build(BuildContext context) {
    final recordProvider = Provider.of<RecordAudioProvider>(context);
    final playProvider = Provider.of<PlayAudioProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://e0.pxfuel.com/wallpapers/502/577/desktop-wallpaper-alone-listening-music-iphone-anime-girl-listening-to-music-thumbnail.jpg"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            recordProvider.recordedFilePath.isEmpty
                ? _recordHeading()
                : _playHeading(),
            SizedBox(
              height: 20,
            ),
            recordProvider.recordedFilePath.isEmpty
                ? _recordingSection()
                : _audioPlayingSection(),
            if (recordProvider.recordedFilePath.isNotEmpty &&
                !playProvider.isSongPlaying)
              SizedBox(
                height: 40,
              ),
            if (recordProvider.recordedFilePath.isNotEmpty &&
                !playProvider.isSongPlaying)
              _resetButton(),
            _showAllRecordings(),
          ],
        ),
      ),
    );
  }

  _recordHeading() {
    return const Center(
        child: Text(
      "Record",
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ));
  }

  _playHeading() {
    return const Center(
        child: Text(
      "Play",
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ));
  }

  _recordingSection() {
    final recordProvider = Provider.of<RecordAudioProvider>(context);
    final recordProviderWithoutListeners =
        Provider.of<RecordAudioProvider>(context, listen: false);

    return recordProvider.isRecording
        ? InkWell(
            onTap: () async =>
                await recordProviderWithoutListeners.stopRecording(),
            child: RippleAnimation(
              repeat: true,
              color: Color(0xff4BB543),
              minRadius: 40,
              ripplesCount: 6,
              child: _recordIcon(),
            ),
          )
        : InkWell(
            child: _recordIcon(),
            onTap: () async =>
                await recordProviderWithoutListeners.recordVoice(),
          );
  }

  _audioPlayingSection() {
    final recordProvider = Provider.of<RecordAudioProvider>(context);
    return Container(
      width: Dimensions.width100,
      height: Dimensions.height15,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.height5),
      margin: EdgeInsets.only(bottom: Dimensions.height5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius2),
          color: Colors.white),
      child: Row(
        children: [
          _audioControllingSection(recordProvider.recordedFilePath),
          _audioProgressionSection()
        ],
      ),
    );
  }

  _audioControllingSection(String audioPath) {
    final playProvider = Provider.of<PlayAudioProvider>(context);

    final playProviderWithoutListeners =
        Provider.of<PlayAudioProvider>(context, listen: false);
    return IconButton(
      onPressed: () async {
        if (audioPath.isEmpty) return;
        await playProviderWithoutListeners.playAudio(File(audioPath));
      },
      icon: Icon(
          playProvider.isSongPlaying ? Icons.pause : Icons.play_arrow_rounded,
          color: Color(0xff4BB543)),
      iconSize: Dimensions.iconSizeSmall4,
    );
  }

  _audioProgressionSection() {
    final playProvider = Provider.of<PlayAudioProvider>(context);

    return Expanded(
        child: Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: Dimensions.height5),
      child: LinearPercentIndicator(
          backgroundColor: Colors.black26,
          percent: playProvider.currLoadingStatus,
          progressColor: Color(0xff4BB543)),
    ));
  }

  _resetButton() {
    final recordProvider =
        Provider.of<RecordAudioProvider>(context, listen: false);

    return Center(
      child: TextButton(
          child: Text("Reset"),
          onPressed: () {
            recordProvider.clearOldData();
          }),
    );
  }

  _recordIcon() {
    return Container(
      width: Dimensions.height25,
      height: Dimensions.height25,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xff4BB543), borderRadius: BorderRadius.circular(100)),
      child: Icon(
        Icons.keyboard_voice_rounded,
        color: Colors.white,
        size: Dimensions.height10,
      ),
    );
  }

  _showAllRecordings() {
    return TextButton(
        onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => AudioRecordings(
                        folders: _folders,
                      )),
            ),
        child: Text("Show Recodings"));
  }

  Future<void> getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/';
    final myDir = new Directory(
        '/storage/emulated/0/Android/data/com.deepak.audio_recorder.audio_recorder/files/recordings/encrypted_files');
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
  }
}
