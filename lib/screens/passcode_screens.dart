// Inside passcode_screens.dart
import 'package:audio_recorder/screens/record_and_play_audio.dart';
import 'package:audio_recorder/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../providers/passcode_provider.dart';


class PasscodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final passcodeProvider = Provider.of<PasscodeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Passcode'),
      ),
      body: Center(
        child: PinCodeTextField(
          appContext: context,
          length: 4, // Set the length of the passcode (e.g., 4 digits)
          onChanged: (passcode) {
            // Handle passcode input, if needed
          },
          onCompleted: (passcode) async {
            final isPasscodeCorrect = await passcodeProvider.checkPasscode(passcode);
            if (isPasscodeCorrect) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SplashPage()),
              );
            } else {
              // Show an error message or reset passcode input
            }
          },
        ),
      ),
    );
  }
}

class SetupPasscodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final passcodeProvider = Provider.of<PasscodeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Passcode'),
      ),
      body: Center(
        child: PinCodeTextField(
          appContext: context,
          length: 4, // Set the length of the passcode (e.g., 4 digits)
          onChanged: (passcode) {
            // Handle passcode input, if needed
          },
          onCompleted: (passcode) {
            passcodeProvider.setPasscode(passcode);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RecordAndPlayScreen()),
            );
          },
        ),
      ),
    );
  }
}
