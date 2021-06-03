import 'dart:math';
import 'dart:ui';

import 'package:gamr/database/points.dart';
import 'package:gamr/point.dart';

class DotList {
  List<Dot> allDots = [];
  List<Dot> drawAbleDots = [];
  double totalDegree = 0;
  double averageY = 0;
  double averageDrawY = 0;
  Paint graphPaint = Paint();

  double offsetX = 0;
  double offsetY = 0;

  double movableScale = 0;
  double scale = 1;

  double movableOffsetX = 0;
  double movableOffsetY = 0;

  double sliderX = 10;
  double sliderY = 10;

  void setNewFixOffset() {
    this.offsetX -= movableOffsetX;
    this.offsetY -= movableOffsetY;
    this.scale += movableScale;
    this.movableOffsetX = 0;
    this.movableOffsetY = 0;
  }

  double getXOffset() {
    return this.offsetX - this.movableOffsetX;
  }

  List<DBPoint> dotsToDBPoint() {
    return this.allDots.map((e) => DBPoint(x: e.x, y: e.y, z: e.z)).toList();
  }

  double getScale() {
    return this.scale + this.movableScale;
  }

  double getYOffset() {
    return this.offsetY - this.movableOffsetY;
  }

  void _sort() {
    allDots.sort((a, b) => a.dx == b.dx
        ? 0
        : a.dx > b.dx
            ? 1
            : -1);
  }

  void addDot(Dot point) {
    allDots.add(point);
    this._sort();
    calculateMetadata();
  }

  void calculateMetadata() {
    calculateAverageY();
    recalculateDrawable();
    calculateDegree();
    if (drawAbleDots.length < 3 && drawAbleDots.length > 0) {
      this.calculateInitialOffset();
    }
  }

  void calculateInitialOffset() {
    this.offsetY = (allDots[0].dy * sliderY / 10 * getScale()) + 50;
    this.offsetX = -(allDots[0].dx * sliderX / 10 * getScale()) + 50;
    recalculateDrawable();
  }

  void recalculateDrawable() {
    if (this.allDots.length > 0) {
      drawAbleDots = allDots
          .map((x) => Dot(x.dx * sliderX / 10 * getScale(),
              x.dy * sliderY / 10 * getScale()))
          .toList();
      drawAbleDots = drawAbleDots
          .map((x) => Dot(x.dx + getXOffset(), -x.dy + getYOffset()))
          .toList();
    }
    calculateAverageDrawY();
  }

  void removeDotIndex(int index) {
    allDots.removeAt(index);
    drawAbleDots.removeAt(index);
    calculateAverageY();
    calculateDegree();
  }

  void removeDot(Dot dot) {
    allDots.remove(dot);
    recalculateDrawable();
    if (allDots.length > 1) {
      calculateAverageY();
      calculateDegree();
    }
  }

  void updateDot(Dot dot) {
    final sameDot = allDots.firstWhere((element) => element.id == dot.id);
    sameDot.updateCoord(dot);
    recalculateDrawable();
    if (allDots.length > 1) {
      calculateAverageY();
      calculateDegree();
    }
  }

  void setPaintColor(Color color) {
    graphPaint.color = color;
  }

  void calculateDegree() {
    if (allDots.length > 1) {
      var first = allDots[0];
      var last = allDots[allDots.length - 1];
      var degree90 = Dot(last.dx, first.dy);
      var a2plusB2 =
          first.distanceFromDotPow(degree90) + first.distanceFromDotPow(last);
      var c2 = degree90.distanceFromDotPow(last);
      var ab2x =
          2 * first.distanceFromDot(last) * first.distanceFromDot(degree90);
      totalDegree = acos((a2plusB2 - c2) / ab2x) * 180 / pi;
    }
  }

  void addMultipleDots(List<Dot> dots) {
    allDots.addAll(dots);
    this._sort();
    calculateAverageY();
    calculateDegree();
  }

  void clear() {
    allDots = [];
    drawAbleDots = [];
    totalDegree = 0;
    averageY = 0;
    averageDrawY = 0;
  }

  void reset() {
    this.sliderX = 10;
    this.sliderY = 10;
    this.scale = 1;

    if (this.drawAbleDots.length > 0) {
      this.calculateInitialOffset();
    }
  }

  void calculateAverageY() {
    if (this.allDots.length > 0) {
      averageY = this.allDots.map((m) => m.dy).reduce((a, b) => a + b) /
          this.allDots.length;
    } else {
      averageY = 0;
    }
  }

  void calculateAverageDrawY() {
    if (this.drawAbleDots.length > 0) {
      averageDrawY =
          this.drawAbleDots.map((m) => m.dy).reduce((a, b) => a + b) /
              this.drawAbleDots.length;
    } else {
      averageDrawY = 0;
    }
  }

  void updateOffset(double offsetX, double offsetY, double scale) {
    if (allDots.length > 1) {
      this.movableScale = (scale - 1);
      this.movableOffsetX = offsetX;
      this.movableOffsetY = offsetY;
      recalculateDrawable();
    }
    return;
  }

  void updateSlider({double? sliderX, double? sliderY}) {
    if (sliderX != null) {
      this.sliderX = sliderX;
    }
    if (sliderY != null) {
      this.sliderY = sliderY;
    }

    recalculateDrawable();
  }

  void updateMainAxis(String value) {
    this.allDots.forEach((element) {
      element.axis = value;
    });
    this.drawAbleDots.forEach((element) {
      element.axis = value;
    });
    calculateMetadata();
  }

  List<Dot> calculateOnDrawPointList(Dot point) {
    Dot min = this.drawAbleDots[0];
    Dot max = this.drawAbleDots[this.drawAbleDots.length - 1];
    if (this.drawAbleDots.length > 1 &&
        point.dx >= min.dx &&
        point.dx <= max.x) {
      int minIndex = 0;

      /// Get points what the dot betwwen
      this.drawAbleDots.asMap().forEach((i, x) {
        if (x.dx > min.dx && x.dx < point.dx) {
          min = x;
          minIndex = i;
        } else if (x.dx < max.dx && x.dx > point.dx) {
          max = x;
        }
      });

      var result = Dot.getYProportion3Dots(min, relative: point, absolute: max);
      var pointToCanvas = Dot(point.x, result);
      var divider = Dot.getVectorRelativeProportion(max,
          relative: pointToCanvas, absolute: min);
      var pointToShow = pointOnLineBetweenDots(minIndex, divider);
      return [pointToCanvas, pointToShow];
    }
    return [];
  }

  Dot pointOnLineBetweenDots(int minMax, Dot divider) {
    var min = allDots[minMax];
    var max = allDots[minMax + 1];

    //Get coordinates aligned by drawing
    var coordXAxisOnCanvas = -(((max.dx - min.dx) /
            (divider.x.isNaN || divider.x == 0 ? 1 : divider.x)) -
        min.dx);
    var coordYAxisOnCanvas = -(((max.dy - min.dy) /
            (divider.y.isNaN || divider.y == 0 ? 1 : divider.y)) -
        min.dy);

    /// Calculate remaining coordinate using percentage of others
    var total = Dot.distanceBetweenDots(min, max);
    var rel = Dot.distanceBetweenDots(
        min, Dot(coordXAxisOnCanvas, coordYAxisOnCanvas));
    var div = rel / total;
    if (max.axis == "XZ") {
      var yd = min.y + (max.y - min.y) * div;
      return Dot.dzParameter(coordXAxisOnCanvas, yd, coordYAxisOnCanvas);
    } else if (max.axis == "XY") {
      var zd = min.z + (max.z - min.z) * div;
      return Dot.dzParameter(coordXAxisOnCanvas, coordYAxisOnCanvas, zd);
    } else {
      var xd = min.x + (max.x - min.x) * div;
      return Dot.dzParameter(xd, coordXAxisOnCanvas, coordYAxisOnCanvas);
    }
  }

  List<Dot> pointsToDrawX() {
    List<Dot> newPoints = [];
    drawAbleDots.forEach((element) {
      newPoints.addAll(element.createXDots());
    });
    return newPoints;
  }
}
