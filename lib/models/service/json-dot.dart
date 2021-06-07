import 'package:gamr/models/drawer/point.dart';

class JsonDot {
  late final int id;

  late final double z;
  late final double x;
  late final double y;

  JsonDot(
      {required this.x, required this.y, required this.z, required this.id});

  static JsonDot fromDot(Dot dot) {
    return JsonDot(x: dot.x, y: dot.y, z: dot.z, id: dot.id);
  }
   static List<JsonDot> generateJSONContentFromDots(List<Dot> dot) {
    final data = dot.map((e) => JsonDot.fromDot(e)).toList();
    return data;
  }

  Map toJson() => {
        'x': x,
        'y': y,
        'z': z,
      };
}
