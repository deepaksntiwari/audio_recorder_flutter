import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../dimensions.dart';
import '../providers/play_audio_provider.dart';
import '../providers/record_audio_provider.dart';

class AudioRecordings extends StatefulWidget {
  final List<FileSystemEntity> folders;

  const AudioRecordings({Key? key, required this.folders}) : super(key: key);

  @override
  State<AudioRecordings> createState() => _AudioRecordingsState();
}

class _AudioRecordingsState extends State<AudioRecordings> {
  List<FileSystemEntity> _folders = [];
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _folders = widget.folders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://e0.pxfuel.com/wallpapers/502/577/desktop-wallpaper-alone-listening-music-iphone-anime-girl-listening-to-music-thumbnail.jpg"))),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Recordings",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _folders.length,
                    itemBuilder: (context, index) {
                      // You need to return a widget here.
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, index);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  height: 30,
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    "${index + 1}. ${_folders[index].path.split('/').last}",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                            Divider(
                              thickness: 2,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _audioControllingSection(String audioPath) {
    final playProvider = Provider.of<PlayAudioProvider>(context);

    final playProviderWithoutListeners =
        Provider.of<PlayAudioProvider>(context, listen: false);

    return Consumer<PlayAudioProvider>(
      builder: (context, playProvider, _) {
        return IconButton(
          onPressed: () async {
            if (audioPath.isEmpty) return;
            await playProviderWithoutListeners.playAudio(File(audioPath));
          },
          icon: Icon(
            playProvider.isSongPlaying ? Icons.pause : Icons.play_arrow_rounded,
            color: Color(0xff4BB543),
          ),
          iconSize: Dimensions.iconSizeMedium,
        );
      },
    );
  }

  _audioProgressionSection() {
    final playProvider = Provider.of<PlayAudioProvider>(context);

    return Consumer<PlayAudioProvider>(builder: (context, playProvider, _) {
      return Expanded(
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.height5),
          child: LinearPercentIndicator(
            backgroundColor: Colors.white,
            percent: playProvider.currLoadingStatus,
            progressColor: Color(0xff4BB543),
          ),
        ),
      );
    });
  }

  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      backgroundColor: Colors.black54,
      context: context,
      isDismissible:
          true, // Allow the BottomSheet to be dismissed on tap outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Stop the audio when the BottomSheet is about to be dismissed
            final playProvider =
                Provider.of<PlayAudioProvider>(context, listen: false);
            await playProvider.stopAudioPlayer();
            return true;
          },
          child: SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _audioControllingSection(_folders[index].path),
                _audioProgressionSection(),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      final playProvider =
          Provider.of<PlayAudioProvider>(context, listen: false);
      playProvider.stopAudioPlayer();
    });
  }
}
