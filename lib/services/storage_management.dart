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

  Future<void> deleteAllFilesInFolder(String folderPath) async {
    // Get a reference to the folder
    final folder = Directory(folderPath);

    if (await folder.exists()) {
      // List all files in the folder
      final files = folder.listSync();

      for (var file in files) {
        if (file is File) {
          // Delete the file
          await file.delete();
        }
      }
      print("${files.length} files deleted");
    } else {
      print("Folder does not exist.");
    }
  }
}
