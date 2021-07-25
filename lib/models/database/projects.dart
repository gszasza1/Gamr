import 'package:gamr/models/database/points.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Project {
  Project(this.name);
  
  int id = 0;
  String name = '';

  @Property(type: PropertyType.date)
  DateTime creation = DateTime.now();

  @Backlink()
  final points = ToMany<DBPoint>();


  @override
  String toString() => name; // Just for print()
}
