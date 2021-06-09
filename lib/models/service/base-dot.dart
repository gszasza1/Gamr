import 'package:gamr/models/drawer/point.dart';

class BaseDot {
  int? id;

  late final double z;
  late final double x;
  late final double y;
  late final String name;

  BaseDot({required this.x, required this.y, required this.z,required this.name, int? id}) {
    if (id != null) {
      this.id = id;
    }
  }

  factory BaseDot.fromDot(Dot dot) {
    return BaseDot(x: dot.x, y: dot.y, z: dot.z, id: dot.id,name: dot.name);
  }

  factory BaseDot.fromNewDot(Dot dot) {
    return BaseDot(x: dot.x, y: dot.y, z: dot.z,name: dot.name);
  }
}
