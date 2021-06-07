import 'dart:convert';
import 'dart:io';

import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/text-dot.dart';
import 'package:path_provider/path_provider.dart';

class TxtService {
  static final TxtService _singleton = TxtService._internal();
  late final String basePath;
  bool isSaveableDevice = true;
  factory TxtService() {
    return _singleton;
  }

  TxtService._internal();

  init() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        this.basePath = dir.path + "/txt";
      } else {
        isSaveableDevice = false;
      }
    } else if (Platform.isIOS) {
      Directory dir = await getApplicationDocumentsDirectory();
      this.basePath = dir.path + "/txt";
    }

    final checkPathExistence = await Directory(basePath).exists();
    if (!checkPathExistence) {
      await new Directory(basePath).create();
    }
  }

  Future<String> createTxtfromDots(
      {required String projectName, required List<Dot> dots}) async {
    final creationDate = DateTime.now()
        .toString()
        .replaceAll(RegExp(r':'), '_')
        .replaceAll(RegExp(r' '), '_')
        .replaceAll(RegExp(r'-'), '_')
        .replaceAll(".", "");
    final fileName = this.basePath + '/${projectName}_$creationDate.txt';
    final data = TextDot.generateStringFromDots(dots);
    print(fileName);
    final File file = File(fileName);
    await file.writeAsString(data);
    return file.path.toString();
  }
}
