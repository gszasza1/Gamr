import 'package:gamr/models/drawer/point.dart';

class TextDot {
  late final int id;

  late final double z;
  late final double x;
  late final double y;

  TextDot(
      {required this.x, required this.y, required this.z, required this.id});

  static TextDot fromDot(Dot dot) {
    return TextDot(x: dot.x, y: dot.y, z: dot.z, id: dot.id);
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
