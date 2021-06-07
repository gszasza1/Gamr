import 'package:gamr/models/database/projects.dart';
import 'package:gamr/models/service/csv-dot.dart';
import 'package:gamr/models/service/json-dot.dart';
import 'package:gamr/models/service/text-dot.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class DBPoint {
  int id = 0;
  double x = 0;

  double y = 0;

  double z = 0;

  final project = ToOne<Project>();

  DBPoint({required this.x, required this.y, required this.z, int? id}) {
    if (id != null) {
      this.id = id;
    }
  }
  static DBPoint fromCSVDot(CSVDot dot) {
    return DBPoint(x: dot.x, y: dot.y, z: dot.z);
  }
  static DBPoint fromJsonDot(JsonDot dot) {
    return DBPoint(x: dot.x, y: dot.y, z: dot.z);
  }
  static DBPoint fromTextDot(TextDot dot) {
    return DBPoint(x: dot.x, y: dot.y, z: dot.z);
  }
}
