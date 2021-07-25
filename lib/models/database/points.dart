import 'package:gamr/models/database/projects.dart';
import 'package:gamr/models/service/base_dot.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class DBPoint {
  DBPoint(
      {required this.x,
      required this.y,
      required this.z,
      required this.name,
      required this.rank,
      int? id}) {
    if (id != null) {
      this.id = id;
    }
  }

  int id = 0;
  int rank = 0;
  double x = 0;

  double y = 0;

  double z = 0;
  String name = "";
  final project = ToOne<Project>();
  
  static DBPoint fromBasePoint(BaseDot dot) {
    return DBPoint(
        x: dot.x, y: dot.y, z: dot.z, name: dot.name, rank: dot.rank);
  }
}
