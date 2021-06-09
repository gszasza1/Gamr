import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/base-dot.dart';

class TextDot extends BaseDot {
  TextDot(
      {required double x,
      required double y,
      required double z,
      required String name,
      int? id})
      : super(x: x, y: y, z: z, id: id, name: name);
  @override
  factory TextDot.fromDot(Dot dot) {
    return TextDot(x: dot.x, y: dot.y, z: dot.z, id: dot.id, name: dot.name);
  }

  static TextDot fromStringList(List<String> dot) {
    if (dot.length != 4) {
      throw UnsupportedError("Nem megfelelő TXT fájl");
    }
    return TextDot(
      x: double.parse(dot[0]),
      y: double.parse(dot[1]),
      z: double.parse(dot[2]),
      name: dot[3],
    );
  }

  String toStringCoord() {
    return "$x $y $z";
  }

  static String listToString(List<TextDot> totalTextDot) {
    String data = "";
    totalTextDot.forEach((element) {
      data += element.toStringCoord() + "\n";
    });
    return data;
  }

  static generateStringFromDots(List<Dot> totalDots) {
    final data = totalDots.map((e) => TextDot.fromDot(e)).toList();
    return TextDot.listToString(data);
  }
}
