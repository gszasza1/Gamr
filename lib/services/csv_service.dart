import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/csv_dot.dart';
import 'package:path_provider/path_provider.dart';

class CSVService {
  static final CSVService _singleton = CSVService._internal();
  late final String basePath;
  bool isSaveableDevice = true;
  factory CSVService() {
    return _singleton;
  }

  CSVService._internal();

  init() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        basePath = "${dir.path}/csv";
      } else {
        isSaveableDevice = false;
      }
    } else if (Platform.isIOS) {
      final Directory dir = await getApplicationDocumentsDirectory();
      basePath = "${dir.path}/csv";
    }

    final checkPathExistence = await Directory(basePath).exists();
    if (!checkPathExistence) {
      await Directory(basePath).create();
    }
  }

  Future<String> createCSVfromDots(
      {required String projectName, required List<Dot> dots}) async {
    final creationDate = DateTime.now()
        .toString()
        .replaceAll(RegExp(r':'), '_')
        .replaceAll(RegExp(r' '), '_')
        .replaceAll(RegExp(r'-'), '_')
        .replaceAll(".", "");
    final fileName = '$basePath${'/${projectName}_$creationDate.csv'}';
    final data = CSVDot.generateCSVContentFromDots(dots);
    final String csvData = const ListToCsvConverter().convert(data);
    final File file = File(fileName);
    await file.writeAsString(csvData);
    return fileName;
  }

  Future<List<DBPoint>> createDotsFromCSV(File readFile) async {
    final fields = await readFile
        .openRead()
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .map((e) => e.map((t) => t.toString()).toList())
        .toList();

    fields.removeAt(0);
    final mappedDots = fields.map((element) {
      return CSVDot.fromStringList(element);
    }).toList();
    final dbPoints = mappedDots.map((element) {
      return DBPoint.fromBasePoint(element);
    }).toList();
    return dbPoints;
  }
}
