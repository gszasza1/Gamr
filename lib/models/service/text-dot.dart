import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/base-dot.dart';

class TextDot extends BaseDot {
  TextDot(
      {required double x,
      required double y,
      required double z,
      required String name,
      required int rank,
      int? id})
      : super(x: x, y: y, z: z, id: id, name: name, rank: rank);
  @override
  factory TextDot.fromDot(Dot dot) {
    return TextDot(
        x: dot.x,
        y: dot.y,
        z: dot.z,
        id: dot.id,
        name: dot.name,
        rank: dot.rank);
  }

  static TextDot fromStringList(List<String> dot) {
    if (dot.length != 5) {
      throw UnsupportedError("Nem megfelelő TXT fájl");
    }
    return TextDot(
      rank: int.tryParse(dot[0]) ?? 0,
      x: double.parse(dot[1]),
      y: double.parse(dot[2]),
      z: double.parse(dot[3]),
      name: dot[4],
    );
  }

  String toStringCoord(int index) {
    return "$index $x $y $z $name";
  }

  static String listToString(List<TextDot> totalTextDot) {
    String data = "";
    totalTextDot.asMap().forEach((index, element) {
      data += element.toStringCoord(index + 1) + "\n";
    });
    return data;
  }

  static generateStringFromDots(List<Dot> totalDots) {
    final data = totalDots.map((e) => TextDot.fromDot(e)).toList();
    return TextDot.listToString(data);
  }
}
