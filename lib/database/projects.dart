import 'package:gamr/database/points.dart';
import 'package:hive/hive.dart';
part 'projects.g.dart';

@HiveType(typeId: 2)
class Project {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  DateTime creation = DateTime.now();

  @HiveField(2)
  List<DBPoint> points=[];

  Project(this.name);

  @override
  String toString() => name; // Just for print()
}
