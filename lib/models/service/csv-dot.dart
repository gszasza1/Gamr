import 'package:gamr/models/drawer/point.dart';

class CSVDot {
  int? id;

  late final double z;
  late final double x;
  late final double y;

  CSVDot({required this.x, required this.y, required this.z, int? id}) {
    if (id != null) {
      this.id = id;
    }
  }

  static CSVDot fromDot(Dot dot) {
    return CSVDot(x: dot.x, y: dot.y, z: dot.z, id: dot.id);
  }

  static CSVDot fromNewDot(Dot dot) {
    return CSVDot(x: dot.x, y: dot.y, z: dot.z);
  }

  static CSVDot fromStringList(List<String> dot) {
    if (dot.length != 3) {
      throw UnsupportedError("Nem megfelelő CSV fájl");
    }
    return CSVDot(
        x: double.parse(dot[0]),
        y: double.parse(dot[1]),
        z: double.parse(dot[2]));
  }

  List<String> toCSVList() {
    return [x.toString(), y.toString(), z.toString()];
  }

  static List<List<String>> generateCSVContent(List<CSVDot> totalCsvDot) {
    List<List<String>> data = [
      ["X", "Y", "Z"],
    ];
    totalCsvDot.forEach((element) {
      data.add(element.toCSVList());
    });
    return data;
  }

  static generateCSVContentFromDots(List<Dot> totalDots) {
    final data = totalDots.map((e) => CSVDot.fromDot(e)).toList();
    return CSVDot.generateCSVContent(data);
  }
}
