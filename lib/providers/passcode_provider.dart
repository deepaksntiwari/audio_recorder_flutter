import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasscodeProvider extends ChangeNotifier {
  late String _passcode;
  bool _isPasscodeSet = false;

  String get passcode => _passcode;

  bool get isPasscodeSet => _isPasscodeSet;

  // Function to set the passcode
  Future<void> setPasscode(String passcode) async {
    _passcode = passcode;
    _isPasscodeSet = true;

    final storage = FlutterSecureStorage();
    await storage.write(key: 'app_passcode', value: passcode);

    notifyListeners();
  }

  // Function to check if the entered passcode matches the stored passcode
  Future<bool> checkPasscode(String enteredPasscode) async {
    final storage = FlutterSecureStorage();
    final storedPasscode = await storage.read(key: 'app_passcode');
    return storedPasscode == enteredPasscode;
  }

  // Function to remove the passcode (e.g., for logout)
  Future<void> removePasscode() async {
    _passcode = "";
    _isPasscodeSet = false;

    final storage = FlutterSecureStorage();
    await storage.delete(key: 'app_passcode');

    notifyListeners();
  }
}
