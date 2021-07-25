import 'dart:convert';
import 'dart:io';

import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/json_dot.dart';
import 'package:path_provider/path_provider.dart';

class JsonService {
  bool isSaveableDevice = true;
  factory JsonService() {
    return _singleton;
  }

  JsonService._internal();
  static final JsonService _singleton = JsonService._internal();
  late final String basePath;

  Future init() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        basePath = "${dir.path}/json";
      } else {
        isSaveableDevice = false;
      }
    } else if (Platform.isIOS) {
      final Directory dir = await getApplicationDocumentsDirectory();
      basePath = "${dir.path}/json";
    }

    final checkPathExistence = await Directory(basePath).exists();
    if (!checkPathExistence) {
      await Directory(basePath).create();
    }
  }

  Future<String> createJsonfromDots(
      {required String projectName, required List<Dot> dots}) async {
    final creationDate = DateTime.now()
        .toString()
        .replaceAll(RegExp(r':'), '_')
        .replaceAll(RegExp(r' '), '_')
        .replaceAll(RegExp(r'-'), '_')
        .replaceAll(".", "");
    final fileName = '$basePath${'/${projectName}_$creationDate.json'}';
    final data = JsonDot.generateJSONContentFromDots(dots);

    final generatedData = data.map((element) => element.toJson()).toList();
    final String jsonTags = jsonEncode(generatedData);
    final File file = File(fileName);
    await file.writeAsString(jsonTags);
    return file.path.toString();
  }

  Future<List<DBPoint>> createDotsFromJson(File readFile) async {
    final List<Map<String, String>> fields =
        json.decode(await readFile.readAsString()) as List<Map<String, String>>;

    final List<JsonDot> mappedDots = List<JsonDot>.from(fields.map((element) {
      return JsonDot.fromMap(Map<String, String>.from(element));
    }).toList());
    final dbPoints = mappedDots.map((element) {
      return DBPoint.fromBasePoint(element);
    }).toList();
    return dbPoints;
  }
}
