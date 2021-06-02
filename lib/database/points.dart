import 'package:hive/hive.dart';
part 'points.g.dart';

@HiveType(typeId: 1)
class DBPoint {
  @HiveField(0)
  double x = 0;

  @HiveField(1)
  double y = 0;

  @HiveField(2)
  double z = 0;
  DBPoint({required this.x, required this.y, required this.z});
}
