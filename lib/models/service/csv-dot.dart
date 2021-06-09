import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/base-dot.dart';

class CSVDot extends BaseDot {
  CSVDot(
      {required double x,
      required double y,
      required String name,
      required double z,
      int? id})
      : super(x: x, y: y, z: z, id: id, name: name);

  static CSVDot fromStringList(List<String> dot) {
    if (dot.length != 3) {
      throw UnsupportedError("Nem megfelelő CSV fájl");
    }
    return CSVDot(
      x: double.parse(dot[0]),
      y: double.parse(dot[1]),
      z: double.parse(dot[2]),
      name: dot[3],
    );
  }

  @override
  factory CSVDot.fromDot(Dot dot) {
    return CSVDot(x: dot.x, y: dot.y, z: dot.z, id: dot.id,name: dot.name);
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
