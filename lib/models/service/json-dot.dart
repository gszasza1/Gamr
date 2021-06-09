import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/base-dot.dart';

class JsonDot extends BaseDot {
  JsonDot(
      {required double x,
      required double y,
      required double z,
      required String name,
      int? id})
      : super(x: x, y: y, z: z, id: id, name: name);
  @override
  factory JsonDot.fromDot(Dot dot) {
    return JsonDot(x: dot.x, y: dot.y, z: dot.z, id: dot.id, name: dot.name);
  }

  static JsonDot fromMap(Map<String, dynamic> dot) {
    if (dot.length != 4 ||
        dot["x"] == null ||
        dot["y"] == null ||
        dot["name"] == null ||
        dot["z"] == null) {
      throw UnsupportedError("Nem megfelelő JSON fájl");
    }
    return JsonDot(
        x: dot["x"]!, y: dot["y"]!, z: dot["z"]!, name: dot["name"]!);
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
