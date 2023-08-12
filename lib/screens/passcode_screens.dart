// Inside passcode_screens.dart
import 'package:audio_recorder/dimensions.dart';
import 'package:audio_recorder/screens/record_and_play_audio.dart';
import 'package:audio_recorder/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../providers/passcode_provider.dart';

class PasscodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final passcodeProvider = Provider.of<PasscodeProvider>(context);

    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/imgs/bg_for_audio_app.jpg"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Text('Enter Passcode'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please enter passcode",
                  style: TextStyle(
                      fontSize: Dimensions.bigFontSize, color: Colors.white),
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                PinCodeTextField(
                  pinTheme: PinTheme(
                      fieldWidth: Dimensions.width20,
                      inactiveColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      activeColor: Colors.orangeAccent,
                      selectedColor: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimensions.radius2)),
                      borderWidth: Dimensions.width10),
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textStyle: TextStyle(color: Colors.white),
                  appContext: context,
                  length: 4, // Set the length of the passcode (e.g., 4 digits)
                  onChanged: (passcode) {
                    // Handle passcode input, if needed
                  },
                  onCompleted: (passcode) async {
                    final isPasscodeCorrect =
                        await passcodeProvider.checkPasscode(passcode);
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
              ],
            ),
          ),
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
