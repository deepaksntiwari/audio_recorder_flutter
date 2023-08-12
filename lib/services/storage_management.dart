import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

class StorageManagement {
  static makeDirectory({required String dirName}) async {
    final Directory? directory = await getExternalStorageDirectory();

    final _formattedDirName = '/$dirName/';

    final Directory _newDir =
        await Directory(directory!.path + _formattedDirName).create();
    return _newDir.path;
  }

  static get getAudioDir async => await makeDirectory(dirName: 'recordings');

  static String createRecordAudioPath(
      {required String dirPath, required String fileName}) {
    return """$dirPath${fileName.substring(0, min(fileName.length, 100))}_${DateTime.now()}.aac""";
  }

  static makeEncryptedDirectory({required String dirName}) async {
    final Directory? directory = await getExternalStorageDirectory();

    final _formattedDirName = '/recordings/$dirName/';

    final Directory _newDir =
        await Directory(directory!.path + _formattedDirName).create();
    return _newDir.path;
  }

  static get getEncryptedDir async =>
      await makeEncryptedDirectory(dirName: "encrypted_files");

    static makeDecryptedDirectory({required String dirName}) async {
    final Directory? directory = await getExternalStorageDirectory();

    final _formattedDirName = '/recordings/$dirName/';

    final Directory _newDir =
        await Directory(directory!.path + _formattedDirName).create();
    return _newDir.path;
  }

  static get getDecryptedDir async =>
      await makeDecryptedDirectory(dirName: "decrypted_files");
}
