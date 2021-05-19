import 'dart:ui';

import 'package:flutter/material.dart';

class OpenPainter extends CustomPainter {
  OpenPainter(
      {required this.sliderX,
      required this.sliderY,
      Offset? paramPoint,
      required this.offsetX}) {
    points = [
      Offset(50, 50),
      Offset(-80, 70),
      Offset(80, 70),
      Offset(380, 10),
      Offset(200, 175),
      Offset(150, 105),
      Offset(300, 75),
      Offset(20, 20),
      Offset(320, 200),
      Offset(89, 125)
    ];
    print(this.offsetX);
    points.sort((a, b) => a.dx == b.dx
        ? 0
        : a.dx > b.dx
            ? 1
            : -1);
    newPoints = points
        .map((x) => Offset(x.dx * sliderX / 10, x.dy * sliderY / 10))
        .toList();
    this.minY = getMinY(newPoints);
    newPoints = newPoints
        .map((x) =>
            Offset(x.dx - newPoints[0].dx + 5 - offsetX, x.dy - minY + 10))
        .toList();
    if (paramPoint != null) {
      localPoint = convertPosition(paramPoint);
      localShow = calculatePoint();
    }
  }
  final double offsetX;
  final double sliderX;
  final double sliderY;
  late List<Offset> points;
  late List<Offset> newPoints;
  Offset? localPoint;
  Offset? localShow;
  final textStyle = TextStyle(
    color: Colors.black,
    fontSize: 10,
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

    canvas.drawPoints(PointMode.lines, pointsToX(newPoints), paint1);
    for (var i = 0; i < points.length - 1; i++) {
      String text = "(" +
          points[i].dx.toStringAsFixed(2) +
          "," +
          points[i].dy.toStringAsFixed(2) +
          ")";
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

      textPainter.paint(canvas, newPoints[i]);
      canvas.drawLine(newPoints[i], newPoints[i + 1], paint1);
    }
    if (this.localPoint != null) {
      String text = "(" +
          this.localShow!.dx.toStringAsFixed(2) +
          "," +
          this.localShow!.dy.toStringAsFixed(2) +
          ")";
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

      textPainter.paint(canvas, this.localPoint!);
      canvas.drawPoints(PointMode.lines, pointToX(this.localPoint!), paint1);
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

  List<Offset> pointToX(Offset point) {
    List<Offset> newPoints = [];
    newPoints.add(Offset(point.dx + 3, point.dy + 3));
    newPoints.add(Offset(point.dx - 3, point.dy - 3));
    newPoints.add(Offset(point.dx + 3, point.dy - 3));
    newPoints.add(Offset(point.dx - 3, point.dy + 3));
    return newPoints;
  }

  Offset convertPosition(Offset point) {
    if (this.newPoints.length > 1) {
      Offset min = this.newPoints[0];
      Offset max = this.newPoints[this.newPoints.length - 1];
      int minIndex = 0;
      Offset calcPoint = Offset(point.dx - offsetX, point.dy);
      this.newPoints.asMap().forEach((i, x) {
        if (x.dx > min.dx && x.dx < calcPoint.dx) {
          min = x;
          minIndex = i;
        } else if (x.dx < max.dx && x.dx > calcPoint.dx) {
          max = x;
        }
      });
      var result = -((((max.dy - min.dy) / (max.dx - min.dx)) *
              (max.dx - calcPoint.dx)) -
          max.dy);
      this.dividerX = (max.dx - min.dx) / (min.dx - point.dx);
      this.dividerY = (max.dy - min.dy) / (min.dy - point.dy);
      this.minMax = minIndex;
      return Offset(calcPoint.dx, result);
    } else
      return Offset(0, 0);
  }

  Offset calculatePoint() {
    var min = points[minMax];
    var max = points[minMax + 1];
    var coordX = -(((max.dx - min.dx) / dividerX) - min.dx);
    var coordY = -(((max.dy - min.dy) / dividerY) - min.dy);
    return Offset(coordX, coordY);
  }
}
