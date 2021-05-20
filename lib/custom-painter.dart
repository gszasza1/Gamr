import 'dart:ui';

import 'package:flutter/material.dart';

class OpenPainter extends CustomPainter {
  OpenPainter({
    required this.showYAxis,
    required this.onlyPoints,
    required this.showCoords,
    required List<Offset> paramPoints,
    required this.sliderX,
    required this.sliderY,
    Offset? paramPoint,
    required this.offsetX,
    required this.offsetY,
  }) {
    points = [...paramPoints];
    points.sort((a, b) => a.dx == b.dx
        ? 0
        : a.dx > b.dx
            ? 1
            : -1);
    if (paramPoints.length > 1) {
      newPoints = points
          .map((x) => Offset(x.dx * sliderX / 10, x.dy * sliderY / 10))
          .toList();
      newPoints = newPoints
          .map((x) => Offset(x.dx - newPoints[0].dx + 5 - offsetX, -x.dy))
          .toList();
      this.minY = getMinY(newPoints);
      newPoints = newPoints
          .map((x) => Offset(x.dx, x.dy - minY + 10 - offsetY))
          .toList();
      if (paramPoint != null) {
        convertPosition(paramPoint);
      }
    }
  }
  final showYAxis;
  final onlyPoints;
  final showCoords;
  final double offsetX;
  final double offsetY;
  final double sliderX;
  final double sliderY;
  List<Offset> points = [];
  List<Offset> newPoints = [];
  Offset? localPoint;
  Offset? localShow;
  final textStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
  );
  double minY = 0;
  int minMax = 0;
  double dividerX = 0;
  double dividerY = 0;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff63aa65)
      ..strokeWidth = 1;
    var paintRed = Paint()
      ..color = Color(0xffff0000)
      ..strokeWidth = 2;
    canvas.drawPoints(PointMode.lines, pointsToX(newPoints), paint1);
    if (this.showYAxis) {
      canvas.drawLine(Offset(0, -minY + 10 - offsetY),
          Offset(size.width, -minY + 10 - offsetY), paint1);
    }

    if (points.length > 1) {
      for (var i = 0; i < points.length - 1; i++) {
        if (this.showCoords) {
          String text = createStringFromCoords(points[i]);
          createNewText(size, text)..paint(canvas, newPoints[i]);
        }
        if (!this.onlyPoints) {
          canvas.drawLine(newPoints[i], newPoints[i + 1], paint1);
        }
      }
      //Draw selected dot
      if (this.localPoint != null) {
        String text = createStringFromCoords(this.localShow!);
        createNewText(size, text)..paint(canvas, this.localPoint!);
        canvas.drawPoints(
            PointMode.lines, pointToX(this.localPoint!), paintRed);
        if (this.showYAxis) {
          var onYAxis = Offset(this.localPoint!.dx, -minY + 10 - offsetY);
          canvas.drawPoints(PointMode.lines, pointToX(onYAxis), paintRed);
          canvas.drawLine(this.localPoint!, onYAxis, paintRed);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double getMinY(List<Offset> newPoint) {
    double currentMinY = newPoint[0].dy;
    newPoint.forEach((element) {
      if (element.dy < currentMinY) {
        currentMinY = element.dy;
      }
    });
    return currentMinY;
  }

  List<Offset> pointsToX(List<Offset> point) {
    List<Offset> newPoints = [];
    point.forEach((element) {
      newPoints.addAll(pointToX(element));
    });
    return newPoints;
  }

  String createStringFromCoords(Offset point) {
    return "(" +
        point.dx.toStringAsFixed(2) +
        "," +
        point.dy.toStringAsFixed(2) +
        ")";
  }

  /// Create X like coordinates from dot
  List<Offset> pointToX(Offset point) {
    List<Offset> newPoints = [];
    newPoints.add(Offset(point.dx + 3, point.dy + 3));
    newPoints.add(Offset(point.dx - 3, point.dy - 3));
    newPoints.add(Offset(point.dx + 3, point.dy - 3));
    newPoints.add(Offset(point.dx - 3, point.dy + 3));
    return newPoints;
  }

  TextPainter createNewText(Size size, String text) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    return textPainter;
  }

  /// Get dot on line Bx X axis
  void convertPosition(Offset point) {
    if (this.newPoints.length > 1 &&
        point.dx >= this.newPoints[0].dx &&
        point.dx <= this.newPoints[this.newPoints.length - 1].dx) {
      Offset min = this.newPoints[0];
      Offset max = this.newPoints[this.newPoints.length - 1];
      int minIndex = 0;

      /// Get points what the dot betwwen
      this.newPoints.asMap().forEach((i, x) {
        if (x.dx > min.dx && x.dx < point.dx) {
          min = x;
          minIndex = i;
        } else if (x.dx < max.dx && x.dx > point.dx) {
          max = x;
        }
      });
      var result =
          -((((max.dy - min.dy) / (max.dx - min.dx)) * (max.dx - point.dx)) -
              max.dy);
      this.dividerX = (max.dx - min.dx) / (min.dx - point.dx);
      this.dividerY = (max.dy - min.dy) / (min.dy - point.dy);

      this.minMax = minIndex;
      localPoint = Offset(point.dx, result);
      localShow = calculatePoint();
    }
  }

  /// Calculate point visible coordinates
  Offset calculatePoint() {
    var min = points[minMax];
    var max = points[minMax + 1];
    if (this.dividerX.isNaN || this.dividerX == 0) {
      this.dividerX = 1;
    }
    if (this.dividerY.isNaN || this.dividerY == 0) {
      this.dividerY = 1;
    }
    var coordX = -(((max.dx - min.dx) / this.dividerX) - min.dx);
    var coordY = -(((max.dy - min.dy) / this.dividerY) - min.dy);
    return Offset(coordX, coordY);
  }
}
