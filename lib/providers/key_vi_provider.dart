import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../screens/splash_screen.dart';

class KeyIvProvider extends ChangeNotifier {
  late Uint8List _key;
  late Uint8List _iv;
  bool _isLoading = true;

  KeyIvProvider() {
    _init();
  }

  bool get isLoading => _isLoading;
  Uint8List get key => _key;
  Uint8List get iv => _iv;

  Future<void> _init() async {
    final storage = FlutterSecureStorage();
    final keyBase64 = await storage.read(key: 'aes_key');
    final ivBase64 = await storage.read(key: 'aes_iv');

    if (keyBase64 != null && ivBase64 != null) {
      _key = base64.decode(keyBase64);
      _iv = base64.decode(ivBase64);
    } else {
      // Generate new AES key and IV if they don't exist
      _key = generateRandomKey(32); // 32 bytes = 256 bits for AES-256
      _iv = generateRandomIV(16); // 16 bytes = AES block size
      // Store the new key and IV securely
      await storage.write(key: 'aes_key', value: base64.encode(_key));
      await storage.write(key: 'aes_iv', value: base64.encode(_iv));
    }

    _isLoading = false;
    notifyListeners();
  }
}
