import 'package:gamr/database/points.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Project {
  int id = 0;
  String name = '';

  DateTime creation = DateTime.now();
  
  @Backlink()
  final points = ToMany<DBPoint>();

  Project(this.name);

  @override
  String toString() => name; // Just for print()
}
