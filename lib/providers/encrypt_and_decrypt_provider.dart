import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_recorder/services/toast_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/storage_management.dart';

class EncryptAndDecryptProvider extends ChangeNotifier {
  encryptAndSaveFile(File incomingAudioFile) async {
    final _encryptDirPath = await StorageManagement.getEncryptedDir;
    String fileName = incomingAudioFile.path.split('/').last;

    Uint8List fileBytes = await incomingAudioFile.readAsBytes();
    // String base64String = base64Encode(fileBytes);

    var enc = await _encryptData(fileBytes);
    String path = await _writeData(enc, _encryptDirPath + '$fileName.aes');
    incomingAudioFile.delete();
    print("file encrypted and saved successfully...$path");
    showToast("file encrypted and saved successfully...$path");
  }

  decryptAndSaveFile(File incomingAudioFile) async {
    final decryptDirPath = await StorageManagement.getDecryptedDir;
    String fileName = incomingAudioFile.path.split('/').last.split('.').first;

    Uint8List fileBytes = await incomingAudioFile.readAsBytes();

    // String base64String = base64Encode(fileBytes);

    var enc = await _decryptData(fileBytes);
    String path = await _writeData(enc, decryptDirPath + '$fileName.acc');
    // print("file decrypted and saved successfully...$path");
    showToast("file decrypted and saved successfully...$path");
    return path;
  }

  Future<List<int>> _encryptData(plainString) async {
    final myEncrypt = MyEncrypt();
    final myEncrypter = await myEncrypt.getEncrypter();

    print("Encrypting File...");
    final encrypted = myEncrypter.encryptBytes(plainString, iv: myEncrypt.iv);
    return encrypted.bytes;
  }

  Future<List<int>> _decryptData(encData) async {
    final myEncrypt = MyEncrypt();
    final myEncrypter = await myEncrypt.getEncrypter();
    print("File decryption in progress...");
    encrypt.Encrypted en = encrypt.Encrypted(encData);
    return myEncrypter.decryptBytes(en, iv: myEncrypt.iv);
  }

  Future<Uint8List> _readData(fileNameWithPath) async {
    print("Reading data...");
    File f = File(fileNameWithPath);
    return await f.readAsBytes();
  }

  Future<String> _writeData(dataToWrite, fileNameWithPath) async {
    print("Writting Data...");
    File f = File(fileNameWithPath);
    await f.writeAsBytes(dataToWrite);
    return f.path.toString();
  }
}

class MyEncrypt {
  late encrypt.Key key;
  late encrypt.IV iv;
  final storage = const FlutterSecureStorage();

  Future<Uint8List> _getKeyFromStorage() async {
    final keyBase64 = await storage.read(key: 'aes_key');
    return base64.decode(keyBase64!);
  }

  Future<Uint8List> _getIVFromStorage() async {
    final ivBase64 = await storage.read(key: 'aes_iv');
    return base64.decode(ivBase64!);
  }

  Future<encrypt.Key> getKey() async {
    final keyData = await _getKeyFromStorage();
    return encrypt.Key(keyData);
  }

  Future<encrypt.IV> getIV() async {
    final ivData = await _getIVFromStorage();
    return encrypt.IV(ivData);
  }

  Future<encrypt.Encrypter> getEncrypter() async {
    key = await getKey();
    iv = await getIV();
    return encrypt.Encrypter(encrypt.AES(key));
  }
}
