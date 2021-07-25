import 'dart:io';

import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/text_dot.dart';
import 'package:path_provider/path_provider.dart';

class TxtService {
  factory TxtService() {
    return _singleton;
  }

  TxtService._internal();
  static final TxtService _singleton = TxtService._internal();
  late final String basePath;
  bool isSaveableDevice = true;

  Future init() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        basePath = "${dir.path}/txt";
      } else {
        isSaveableDevice = false;
      }
    } else if (Platform.isIOS) {
      final Directory dir = await getApplicationDocumentsDirectory();
      basePath = "${dir.path}/txt";
    }

    final checkPathExistence = await Directory(basePath).exists();
    if (!checkPathExistence) {
      await Directory(basePath).create();
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
    final fileName = '$basePath${'/${projectName}_$creationDate.txt'}';
    final data = TextDot.generateStringFromDots(dots);
    final File file = File(fileName);
    await file.writeAsString(data);
    return file.path.toString();
  }

  Future<List<DBPoint>> createDotsFromTxt(File readFile) async {
    final fields = (await readFile.readAsString()).split("\n");
    fields.removeWhere((element) => element.length < 3);
    final listFields = fields.map((e) => e.split(" ").toList()).toList();

    final mappedDots = listFields.map((element) {
      return TextDot.fromStringList(element);
    }).toList();
    final dbPoints = mappedDots.map((element) {
      return DBPoint.fromBasePoint(element);
    }).toList();
    return dbPoints;
  }
}
