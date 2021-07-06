import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gamr/config/config.dart';
import 'package:gamr/config/options.dart';
import 'package:gamr/models/drawer/dot-list.dart';
import 'package:gamr/models/drawer/point.dart';

class OpenPainter extends CustomPainter {
  OpenPainter({
    required this.options,
    required Dot? paramPoint,
    required this.dotList,
    required this.axis,
  }) {}

  final GamrOptions options;
  final String axis;
  final DotList dotList;

  @override
  void paint(Canvas canvas, Size size) {
    /// Colors init
    var paintGreen = Paint()
      ..color = Config.colorGreen
      ..strokeWidth = 1;

    var paintGreen30 = Paint()
      ..color = Config.colorGreen30
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    var paintRed = Paint()
      ..color = Config.colorRed
      ..strokeWidth = 2;

    var paintBlack = Paint()
      ..color = Config.colorBlack
      ..strokeWidth = 1;

    /// Axis show
    /// X
    /// Line
    canvas.drawLine(Dot(0, size.height - 15), Dot(size.width, size.height - 15),
        paintBlack);

    /// Nyíl
    canvas.drawLine(Dot(size.width - 5, size.height - 20),
        Dot(size.width, size.height - 15), paintBlack);
    canvas.drawLine(Dot(size.width - 5, size.height - 10),
        Dot(size.width, size.height - 15), paintBlack);

    /// Y
    /// Line
    canvas.drawLine(Dot(15, 0), Dot(15, size.height), paintBlack);

    ///Nyíl
    canvas.drawLine(Dot(10, 5), Dot(15, 0), paintBlack);
    canvas.drawLine(Dot(20, 5), Dot(15, 0), paintBlack);
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
                  showNumber:
                      options.showNumber ? dotList.allDots[i].rank : null,
                  showCoord: this.options.showCoords,
                  threeCoord: true))
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

      /// Show average Y height on X axis
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

      /// Draw distance dot
      if (this.options.show2Ddistance) {
        this.dotList.distances.forEach((element) {
          createNewText(size, element.distance.toStringAsFixed(5),
              color: Config.colorDarkPurple)
            ..paint(canvas, element);
        });
      }

      /// Draw distance dot 3D
      if (this.options.show3Ddistance) {
        this.dotList.distances3D.forEach((element) {
          createNewText(size, element.distance.toStringAsFixed(5),
              color: Config.colorDarkPurple)
            ..paint(canvas, element);
        });
      }

      /// HeightVariation
      if (this.options.showHeightVariation) {
        this.dotList.zHeightVariationList.forEach((element) {
          createNewText(size, element.distance.toStringAsFixed(5),
              color: Config.colorBlack)
            ..paint(canvas, element);
        });
      }

      /// Draw selected dot
      if (this.dotList.selectedPoint.length > 1) {
        createNewText(size,
            this.dotList.selectedPoint[1].coordsToString(threeCoord: true),
            color: Config.colorRed)
          ..paint(canvas, this.dotList.selectedPoint[0]);
        canvas.drawPoints(PointMode.lines,
            this.dotList.selectedPoint[0].createXDots(), paintRed);

        if (this.options.showYAxis) {
          var onYAxis =
              Dot(this.dotList.selectedPoint[0].dx, this.dotList.getYOffset());
          canvas.drawPoints(PointMode.lines, onYAxis.createXDots(), paintRed);
          canvas.drawLine(this.dotList.selectedPoint[0], onYAxis, paintRed);
        }
      }

      /// SelectedPoints (round)
      var paintCircularPurple = Paint()
        ..color = Config.colorDarkPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      this.dotList.twoDotMode.selectedDotIndexes.forEach((element) {
        canvas.drawCircle(
            this.dotList.drawAbleDots[element], 10, paintCircularPurple);
      });

      /// Összekötni ha 2 pont ki van választva
      if (this.dotList.twoDotMode.selectedDotIndexes.length == 2) {
        canvas.drawLine(
            this
                .dotList
                .drawAbleDots[this.dotList.twoDotMode.selectedDotIndexes[0]],
            this
                .dotList
                .drawAbleDots[this.dotList.twoDotMode.selectedDotIndexes[1]],
            paintCircularPurple);

        /// Felosztás
        final drawSelectedDots = this.dotList.twoDotMode.drawDistanceDots;
        for (var i = 0; i < drawSelectedDots.length; i++) {
          canvas.drawPoints(
              PointMode.lines, drawSelectedDots[i].createXDots(), paintRed);
          //Felosztás szövege
          if (this.options.showCoords) {
            createNewText(
                size,
                this
                    .dotList
                    .twoDotMode
                    .distanceDots[i]
                    .coordsToString(threeCoord: true),
                color: Config.colorRed)
              ..paint(canvas, drawSelectedDots[i]);
          }
        }
      }

      ///Area caluclation
      final areaDots = this.dotList.areaMode.selectedDrawDots;
      areaDots.forEach((element) {
        canvas.drawCircle(element, 5, paintGreen);
      });
      if (areaDots.length > 2) {
        Path path = Path();
        path.addPolygon(areaDots, true);
        canvas.drawPath(path, paintGreen30);
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
