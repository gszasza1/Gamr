import 'package:objectbox/objectbox.dart';

@Entity()
class DBPoint {
  int id = 0;
  double x = 0;

  double y = 0;

  double z = 0;
  DBPoint({required this.x, required this.y, required this.z});
}
