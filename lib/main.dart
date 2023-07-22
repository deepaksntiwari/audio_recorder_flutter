import 'package:audio_recorder/providers/play_audio_provider.dart';
import 'package:audio_recorder/providers/record_audio_provider.dart';
import 'package:audio_recorder/screens/record_and_play_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const EntryRoot());
}

class EntryRoot extends StatelessWidget {
  const EntryRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordAudioProvider()),
        ChangeNotifierProvider(create: (_) => PlayAudioProvider())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Record & Play',
        home: RecordAndPlayScreen(),
      ),
    );
  }
}
