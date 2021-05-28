import 'dart:math';
import 'dart:ui';

class Dot extends Offset {
  double z = 0;
  double x = 0;
  double y = 0;
  String axis = "XY";

  Dot(double dx, double dy) : super(dx, dy) {
    x = dx;
    y = dy;
  }
  Dot.dzParameter(double dx, double dy, this.z) : super(dx, dy) {
    x = dx;
    y = dy;
  }

  double distanceFromDot(Dot dot) {
    return sqrt(distanceFromDotPow(dot));
  }

  @override
  double get dx {
    if (axis == "XY") {
      return this.x;
    } else if (axis == "XZ") {
      return this.x;
    } else {
      return this.y;
    }
  }

  @override
  double get dy {
    if (axis == "XY") {
      return this.y;
    } else if (axis == "XZ") {
      return this.z;
    } else {
      return this.z;
    }
  }

  double distanceFromDotPow(Dot dot) {
    var a = this.dx - dot.dx;
    var b = this.dy - dot.dy;
    return a * a + b * b;
  }

  static double distanceBetweenDots(Dot dot1, Dot dot2) {
    var a = dot1.dx - dot2.dx;
    var b = dot1.dy - dot2.dy;
    return sqrt(a * a + b * b);
  }

  String coordsToString(
      {int? showNumber, bool showCoord = true, bool threeCoord = false}) {
    if (showNumber != null && showCoord) {
      return showNumber.toString() + " " + _createLocalCoords(threeCoord);
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
      return " X: " +
          this.x.toStringAsFixed(2) +
          "\n Y:" +
          this.y.toStringAsFixed(2) +
          "\n Z:" +
          this.z.toStringAsFixed(2);
    } else {
      return "(" +
          this.x.toStringAsFixed(2) +
          ", " +
          this.y.toStringAsFixed(2) +
          ")";
    }
  }

  static coordsParamToString(double x, double y,
      {int? showNumber, bool showCoord = true}) {
    var coord = "(" + x.toStringAsFixed(2) + ", " + y.toStringAsFixed(2) + ")";
    return showNumber != null
        ? showNumber.toString() + " " + coord
        : showCoord
            ? coord
            : showNumber.toString();
  }

  List<Dot> createXDots() {
    List<Dot> newPoints = [];
    newPoints.add(Dot(this.dx + 3, this.dy + 3));
    newPoints.add(Dot(this.dx - 3, this.dy - 3));
    newPoints.add(Dot(this.dx + 3, this.dy - 3));
    newPoints.add(Dot(this.dx - 3, this.dy + 3));
    return newPoints;
  }

  Dot movePointBy(Dot vector) {
    return Dot(this.dx + vector.dx, this.dy + vector.dy);
  }

  static Dot getVectorRelativeProportion(Dot common,
      {required Dot relative, required Dot absolute}) {
    double dividerX = 1;
    double dividerY = 1;
    double dividerZ = 1;
    if (common.axis == "XY") {
      dividerX = (common.dx - absolute.dx) / (absolute.dx - relative.dx);
      dividerY = (common.dy - absolute.dy) / (absolute.dy - relative.dy);
      dividerZ = (common.z - absolute.z) / (absolute.z - relative.z);
    }
    if (common.axis == "XY") {
      dividerX = (common.dx - absolute.dx) / (absolute.dx - relative.dx);
      dividerY = (common.dy - absolute.dy) / (absolute.dy - relative.dy);
      dividerZ = (common.z - absolute.z) / (absolute.z - relative.z);
    }

    return Dot.dzParameter(dividerX, dividerY, dividerZ);
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
