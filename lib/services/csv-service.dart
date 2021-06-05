import 'dart:io';
import 'package:csv/csv.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/csv-dot.dart';
import 'package:path_provider/path_provider.dart';

class CSVService {
  static final CSVService _singleton = CSVService._internal();
  late final String basePath;
  factory CSVService() {
    return _singleton;
  }

  CSVService._internal();

  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    this.basePath = dir.path + "/csv";
  }

  Future<void> createCSVfromDots(
      {required String projectName, required List<Dot> dots}) async {
    final fileName =
        this.basePath + '/${projectName}_${DateTime.now().toString()}.csv';
    final data = CSVDot.generateCSVContentFromDots(dots);
    String csvData = ListToCsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    print(fileName);
    final File file = File(fileName);
    await file.writeAsString(csvData);
  }
}
