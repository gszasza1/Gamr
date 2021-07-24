import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/base_dot.dart';

class JsonDot extends BaseDot {
  JsonDot(
      {required double x,
      required double y,
      required double z,
      required String name,
      required int rank,
      int? id})
      : super(x: x, y: y, z: z, id: id, name: name, rank: rank);
  @override
  factory JsonDot.fromDot(Dot dot) {
    return JsonDot(
        x: dot.x,
        y: dot.y,
        z: dot.z,
        id: dot.id,
        name: dot.name,
        rank: dot.rank);
  }

  static JsonDot fromMap(Map<String, String> dot) {
    if (dot.length != 5 ||
        dot["x"] == null ||
        dot["y"] == null ||
        dot["name"] == null ||
        dot["z"] == null) {
      throw UnsupportedError("Nem megfelelő JSON fájl");
    }
    return JsonDot(
        rank: int.parse(dot["rank"]!),
        x: double.parse(dot["x"]!),
        y: double.parse(dot["y"]!),
        z: double.parse(dot["z"]!),
        name: dot["name"]!);
  }

  static List<JsonDot> generateJSONContentFromDots(List<Dot> dot) {
    final data = dot.map((e) => JsonDot.fromDot(e)).toList();
    return data;
  }

  Map toJson() => {'rank': rank, 'x': x, 'y': y, 'z': z, 'name': name};
}
