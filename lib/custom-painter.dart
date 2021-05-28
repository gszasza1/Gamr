import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gamr/config.dart';
import 'package:gamr/dot-list.dart';
import 'package:gamr/options.dart';
import 'package:gamr/point.dart';

class OpenPainter extends CustomPainter {
  OpenPainter({
    required this.options,
    required Dot? paramPoint,
    required this.dotList,
    required this.axis,
  }) {
    if (this.dotList.drawAbleDots.length > 1 && paramPoint != null) {
      selectedPoint = this.dotList.calculateOnDrawPointList(paramPoint);
    } else {
      selectedPoint = [];
    }
  }

  final GamrOptions options;
  final String axis;
  late List<Dot> selectedPoint;
  final DotList dotList;

  @override
  void paint(Canvas canvas, Size size) {
    var paintGreen = Paint()
      ..color = Config.colorGreen
      ..strokeWidth = 1;

    var paintRed = Paint()
      ..color = Config.colorRed
      ..strokeWidth = 2;

    var paintBlack = Paint()
      ..color = Config.colorBlack
      ..strokeWidth = 1;

    /// Axis show
    canvas.drawLine(Dot(0, size.height - 15), Dot(size.width, size.height - 15),
        paintBlack);
    canvas.drawLine(Dot(15, 0), Dot(15, size.height), paintBlack);
    late String textX;
    late String textY;
    if (this.axis == "XY") {
      textX = "X";
      textY = "Y";
    }
    if (this.axis == "XZ") {
      textX = "X";
      textY = "Z";
    }
    if (this.axis == "YZ") {
      textX = "Y";
      textY = "Z";
    }
    createNewText(size, textX)..paint(canvas, Offset(35, size.height - 15));
    createNewText(size, textY)..paint(canvas, Offset(3, size.height - 45));

    // For all points draw X on Canvas
    canvas.drawPoints(
        PointMode.lines, dotList.pointsToDrawX(), dotList.graphPaint);

    // Draw Y axis on Canvas
    if (this.options.showYAxis) {
      canvas.drawLine(Dot(0, this.dotList.getYOffset()),
          Dot(size.width, this.dotList.getYOffset()), paintGreen);
    }

    /// Create graph from all dots
    if (dotList.allDots.length > 1 && dotList.drawAbleDots.length > 1) {
      for (var i = 0; i < dotList.allDots.length; i++) {
        if (this.options.showCoords || this.options.showNumber) {
          createNewText(
              size,
              dotList.allDots[i].coordsToString(
                  showNumber: options.showNumber ? i + 1 : null,
                  showCoord: this.options.showCoords))
            ..paint(canvas, dotList.drawAbleDots[i]);
        }

        if (!this.options.onlyPoints && dotList.drawAbleDots.length - 1 > i) {
          canvas.drawLine(
              dotList.drawAbleDots[i], dotList.drawAbleDots[i + 1], paintGreen);
        }
      }

      /// Create line between first and last point
      if (this.options.showTotalDegree &&
          this.dotList.drawAbleDots.length > 1) {
        var paintOrange = Paint()
          ..color = Config.colorOrange
          ..strokeWidth = 2;

        canvas.drawLine(
            this.dotList.drawAbleDots[0],
            this.dotList.drawAbleDots[this.dotList.drawAbleDots.length - 1],
            paintOrange);
      }

      // Show average Y height on X axis
      if (this.options.showMedian) {
        var paintPurple = Paint()
          ..color = Config.colorPurple
          ..strokeWidth = 2;

        var averageYDot = Dot(0, this.dotList.averageDrawY);

        createNewText(size, Dot.coordsParamToString(0, this.dotList.averageY))
          ..paint(canvas, averageYDot);
        canvas.drawLine(averageYDot, Dot(size.width, this.dotList.averageDrawY),
            paintPurple);
      }

      //Draw selected dot
      if (this.selectedPoint.length > 1) {
        createNewText(
            size, this.selectedPoint[1].coordsToString(threeCoord: true),
            color: Config.colorRed)
          ..paint(canvas, this.selectedPoint[0]);
        canvas.drawPoints(
            PointMode.lines, this.selectedPoint[0].createXDots(), paintRed);

        if (this.options.showYAxis) {
          var onYAxis =
              Dot(this.selectedPoint[0].dx, this.dotList.getYOffset());
          canvas.drawPoints(PointMode.lines, onYAxis.createXDots(), paintRed);
          canvas.drawLine(this.selectedPoint[0], onYAxis, paintRed);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  TextPainter createNewText(Size size, String text, {Color? color}) {
    TextStyle textStyle = TextStyle(
      color: color ?? Colors.black,
      fontSize: 14,
    );
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
}
