import 'dart:math';
import 'dart:ui';

class Dot extends Offset {
  Dot(double dx, double dy) : super(dx, dy);

  double distanceFromDot(Dot dot) {
    return sqrt(distanceFromDotPow(dot));
  }

  double distanceFromDotPow(Dot dot) {
    var a = this.dx - dot.dx;
    var b = this.dy - dot.dy;
    return a * a + b * b;
  }

  String coordsToString() {
    return "(" +
        this.dx.toStringAsFixed(2) +
        "," +
        this.dy.toStringAsFixed(2) +
        ")";
  }

  static coordsParamToString(double x, double y) {
    return "(" + x.toStringAsFixed(2) + "," + y.toStringAsFixed(2) + ")";
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
    var dividerX = (common.dx - absolute.dx) / (absolute.dx - relative.dx);
    var dividerY = (common.dy - absolute.dy) / (absolute.dy - relative.dy);
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
