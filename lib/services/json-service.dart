import 'dart:convert';
import 'dart:io';

import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/json-dot.dart';
import 'package:path_provider/path_provider.dart';

class JsonService {
  static final JsonService _singleton = JsonService._internal();
  late final String basePath;
  bool isSaveableDevice = true;
  factory JsonService() {
    return _singleton;
  }

  JsonService._internal();

  init() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        this.basePath = dir.path + "/json";
      } else {
        isSaveableDevice = false;
      }
    } else if (Platform.isIOS) {
      Directory dir = await getApplicationDocumentsDirectory();
      this.basePath = dir.path + "/json";
    }

    final checkPathExistence = await Directory(basePath).exists();
    if (!checkPathExistence) {
      await new Directory(basePath).create();
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
    final fileName = this.basePath + '/${projectName}_$creationDate.json';
    final data = JsonDot.generateJSONContentFromDots(dots);
    
    var generatedData = [];
    for (var i = 0; i < data.length; i++) {
      generatedData.add(data[i].toJson(i));
    }

    String jsonTags = jsonEncode(generatedData);
    print(fileName);
    final File file = File(fileName);
    await file.writeAsString(jsonTags);
    return file.path.toString();
  }

  Future<List<DBPoint>> createDotsFromJson(File readFile) async {
    var fields = json.decode(await readFile.readAsString());

    final List<JsonDot> mappedDots = List<JsonDot>.from(fields.map((element) {
      return JsonDot.fromMap(Map<String, dynamic>.from(element));
    }).toList());
    final dbPoints = mappedDots.map((element) {
      return DBPoint.fromBasePoint(element);
    }).toList();
    return dbPoints;
  }
}
