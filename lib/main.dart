import 'package:audio_recorder/providers/encrypt_and_decrypt_provider.dart';
import 'package:audio_recorder/providers/key_vi_provider.dart';
import 'package:audio_recorder/providers/play_audio_provider.dart';
import 'package:audio_recorder/providers/record_audio_provider.dart';
import 'package:audio_recorder/screens/record_and_play_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'providers/passcode_provider.dart';
import 'screens/passcode_screens.dart';

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
        ChangeNotifierProvider(create: (_) => PlayAudioProvider()),
        ChangeNotifierProvider(create: (_) => EncryptAndDecryptProvider()),
        ChangeNotifierProvider(create: (_) => KeyIvProvider()),
        ChangeNotifierProvider(create: (_) => PasscodeProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Record & Play',
        home: PasscodeWrapper(),
      ),
    );
  }
}

class PasscodeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final passcodeProvider = Provider.of<PasscodeProvider>(context);

    return FutureBuilder<bool>(
      future: _checkPasscodeSetup(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final isPasscodeSet = snapshot.data ?? false;

          if (isPasscodeSet) {
            return PasscodeScreen();
          } else {
            return SetupPasscodeScreen();
          }
        }
      },
    );
  }

  Future<bool> _checkPasscodeSetup() async {
    final storage = FlutterSecureStorage();
    final passcode = await storage.read(key: 'app_passcode');
    return passcode != null;
  }
}
