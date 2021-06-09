import 'package:gamr/models/database/projects.dart';
import 'package:gamr/models/service/base-dot.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class DBPoint {
  int id = 0;
  double x = 0;

  double y = 0;

  double z = 0;
  String name = "";
  final project = ToOne<Project>();

  DBPoint(
      {required this.x,
      required this.y,
      required this.z,
      required this.name,
      int? id}) {
    if (id != null) {
      this.id = id;
    }
  }
  static DBPoint fromBasePoint(BaseDot dot) {
    return DBPoint(x: dot.x, y: dot.y, z: dot.z, name: dot.name);
  }
}
