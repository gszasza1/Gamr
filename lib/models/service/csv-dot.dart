import 'package:gamr/models/drawer/point.dart';

class CSVDot {
  late final int id;

  late final double z;
  late final double x;
  late final double y;

  CSVDot({required this.x, required this.y, required this.z, required this.id});

  static CSVDot fromDot(Dot dot) {
    return CSVDot(x: dot.x, y: dot.y, z: dot.z, id: dot.id);
  }

  List<String> toCSVList() {
    return [id.toString(), x.toString(), y.toString(), z.toString()];
  }

  static List<List<String>> generateCSVContent(List<CSVDot> totalCsvDot) {
    List<List<String>> data = [
      ["Id.", "X", "Y", "Z"],
    ];
    totalCsvDot.forEach((element) {
      data.add(element.toCSVList());
    });
    return data;
  }
  static generateCSVContentFromDots(List<Dot> totalDots){
    final data = totalDots.map((e) => CSVDot.fromDot(e)).toList();
    return CSVDot.generateCSVContent(data);
  }

}
