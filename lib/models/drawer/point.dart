import 'dart:math';
import 'dart:ui';

import 'package:gamr/models/database/points.dart';

class Dot extends Offset {
  /// Only for data points. Not for draw points
  int id = 0;

  double z = 0;
  int rank = 0;
  double x = 0;
  double y = 0;
  String name = "";
  String axis = "XY";

  Dot(double dx, double dy, {int? id, String? name}) : super(dx, dy) {
    x = dx;
    y = dy;
    if (id != null) {
      this.id = id;
    }
    if (name != null) {
      this.name = name;
    }
  }

  Dot.fromOffset(Offset offset) : super(offset.dx, offset.dy) {
    x = offset.dx;
    y = offset.dy;
  }

  Dot.dzParameter(double dx, double dy, this.z,
      {int? id, String? name, int? rank})
      : super(dx, dy) {
    x = dx;
    y = dy;
    if (id != null) {
      this.id = id;
    }
    if (name != null) {
      this.name = name;
    }
    if (rank != null) {
      this.rank = rank;
    }
  }
  DBPoint toDbPoint() {
    return DBPoint(x: x, y: y, z: z, id: id, name: name, rank: rank);
  }

  updateCoord(Dot dot) {
    name = dot.name;
    rank = dot.rank;
    x = dot.x;
    y = dot.y;
    z = dot.z;
  }

  double distanceFromDot(Dot dot) {
    return sqrt(distanceFromDotPow(dot));
  }

  double distanceFromDot3D(Dot dot) {
    return sqrt(distanceFromDotPow3D(dot));
  }

  @override
  double get dx {
    if (axis == "XY") {
      return x;
    } else if (axis == "XZ") {
      return x;
    } else {
      return y;
    }
  }

  @override
  double get dy {
    if (axis == "XY") {
      return y;
    } else if (axis == "XZ") {
      return z;
    } else {
      return z;
    }
  }

  double distanceFromDotPow(Dot dot) {
    final a = dx - dot.dx;
    final b = dy - dot.dy;
    return a * a + b * b;
  }

  double distanceFromDotPow3D(Dot dot) {
    final a = x - dot.x;
    final b = y - dot.y;
    final c = z - dot.z;
    return a * a + b * b + c * c;
  }

  static double distanceBetweenDots(Dot dot1, Dot dot2) {
    final a = dot1.dx - dot2.dx;
    final b = dot1.dy - dot2.dy;
    return sqrt(a * a + b * b);
  }

  static double distanceBetween3DDots(Dot dot1, Dot dot2) {
    final a = dot1.x - dot2.x;
    final b = dot1.y - dot2.y;
    final c = dot1.z - dot2.z;
    return sqrt(a * a + b * b + c * c);
  }

  String coordsToString(
      {int? showNumber, bool showCoord = true, bool threeCoord = false}) {
    if (showNumber != null && showCoord) {
      return "$showNumber ${_createLocalCoords(threeCoord)}";
    } else if (showNumber != null) {
      return showNumber.toString();
    } else if (showCoord) {
      return _createLocalCoords(threeCoord);
    } else {
      return "";
    }
  }

  String _createLocalCoords(bool threeCoord) {
    if (threeCoord) {
      return " X: ${x.toStringAsFixed(2)}\n Y: ${y.toStringAsFixed(2)}\n Z: ${z.toStringAsFixed(2)}";
    } else {
      return "(${dx.toStringAsFixed(2)}, ${dy.toStringAsFixed(2)})";
    }
  }

  static String coordsParamToString(double x, double y,
      {int? showNumber, bool showCoord = true}) {
    final coord = "(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})";
    return showNumber != null
        ? "$showNumber $coord"
        : showCoord
            ? coord
            : showNumber.toString();
  }

  List<Dot> createXDots() {
    final List<Dot> newPoints = [];
    newPoints.add(Dot(dx + 3, dy + 3));
    newPoints.add(Dot(dx - 3, dy - 3));
    newPoints.add(Dot(dx + 3, dy - 3));
    newPoints.add(Dot(dx - 3, dy + 3));
    return newPoints;
  }

  Dot movePointBy(Dot vector) {
    return Dot(dx + vector.dx, dy + vector.dy);
  }

  static Dot getVectorRelativeProportion(Dot common,
      {required Dot relative, required Dot absolute}) {
    double dividerX = 1;
    double dividerY = 1;
    dividerX = (common.dx - absolute.dx) / (absolute.dx - relative.dx);
    dividerY = (common.dy - absolute.dy) / (absolute.dy - relative.dy);

    return Dot(dividerX, dividerY);
  }

  static getYProportion3Dots(Dot common,
      {required Dot relative, required Dot absolute}) {
    return -((common.dx - relative.dx) *
            (absolute.dy - common.dy) /
            (absolute.dx - common.dx)) +
        common.dy;
  }

  static Dot offsetToDot(Offset offset) {
    return Dot(offset.dx, offset.dy);
  }
}
