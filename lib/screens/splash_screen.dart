import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:audio_recorder/screens/record_and_play_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../providers/key_vi_provider.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<KeyIvProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const CircularProgressIndicator();
            } else {
              // Navigate to the next screen after initialization
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkIfDialogShown(context, provider.key, provider.iv);
              });
              return Container(); // Return an empty container while showing the dialog
            }
          },
        ),
      ),
    );
  }

  Future<void> _checkIfDialogShown(
      BuildContext context, Uint8List key, Uint8List iv) async {
    final storage = FlutterSecureStorage();
    final isDialogShown = await storage.read(key: 'is_dialog_shown') == 'true';

    if (!isDialogShown) {
      await storage.write(key: 'is_dialog_shown', value: 'true');
      _showKeyAndIvDialog(context, key, iv);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecordAndPlayScreen(),
        ),
      );
    }
  }

  void _showKeyAndIvDialog(BuildContext context, Uint8List key, Uint8List iv) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('AES Key and IV'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AES Key: ${base64.encode(key)}'),
              const SizedBox(height: 10),
              Text('Initialization Vector (IV): ${base64.encode(iv)}'),
              const SizedBox(height: 10),
              const Text(
                'IMPORTANT: Please securely store this information. If you lose these values, you may permanently lose access to your encrypted data.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecordAndPlayScreen(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('This is the Home Page'),
      ),
    );
  }
}

Uint8List generateRandomKey(int length) {
  // Function to generate a random key
  final random = Random.secure();
  final key = Uint8List(length);
  for (var i = 0; i < length; i++) {
    key[i] = random.nextInt(256);
  }
  return key;
}

Uint8List generateRandomIV(int length) {
  // Function to generate a random IV
  final random = Random.secure();
  final iv = Uint8List(length);
  for (var i = 0; i < length; i++) {
    iv[i] = random.nextInt(256);
  }
  return iv;
}
