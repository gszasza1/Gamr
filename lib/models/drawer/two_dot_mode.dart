import 'dart:math';

import 'package:gamr/models/drawer/point.dart';

class TwoDotMode {
  List<int> selectedDotIndexes = [];
  List<Dot> selectedDots = [];

  double? dividerMeasure;

  List<Dot> drawDistanceDots = [];
  List<Dot> distanceDots = [];

  bool isEqualDistances = false;

  /// MetaData between dots
  double distance3D = 0;
  double distance2D = 0;
  double degreeBeteenDots = 0;

  //m
  double zHeightVariationBetweenDots = 0;

  //100 méteren 1 centi -> 1%
  double zHeightDegree = 0;

  bool continueMode = false;

  setDot(int index, Dot dot) {
    if (selectedDotIndexes.length < 2) {
      if (!selectedDotIndexes.contains(index)) {
        selectedDotIndexes.add(index);
        selectedDots.add(dot);
        if (selectedDots.length == 2) {
          calculate2DDistance();
          calculate3DDistance();
          calculateZHeightVariation();
          calculateDegree();
          calculateZHeightDegree();
        }
      }
      return;
    } else {
      selectedDotIndexes = [index];
      selectedDots = [dot];
      drawDistanceDots = [];
      distanceDots = [];
    }
  }

  bool get isFull {
    return selectedDotIndexes.length == 2;
  }

  bool get havePoint {
    return selectedDots.isNotEmpty;
  }

  reset() {
    selectedDotIndexes = [];
    drawDistanceDots = [];
    distanceDots = [];
    selectedDots = [];
    dividerMeasure = null;
  }

  resetPoints() {
    drawDistanceDots = [];
    distanceDots = [];
  }

  calculate2DDistance() {
    distance2D = (selectedDots[0].distanceFromDot(selectedDots[1])).abs();
  }

  calculate3DDistance() {
    distance3D = (selectedDots[0].distanceFromDot3D(selectedDots[1])).abs();
  }

  calculateZHeightDegree() {
    zHeightDegree = zHeightVariationBetweenDots / distance2D * 100 * 100;
    zHeightDegree = tan(degreeBeteenDots * pi / 180) * 100;
  }

  calculateZHeightVariation() {
    zHeightVariationBetweenDots = (selectedDots[0].z - selectedDots[1].z).abs();
  }

  calculateDegree() {
    final first = selectedDots[0];
    final last = selectedDots[1];
    final degree90 = Dot.dzParameter(last.x, last.y, first.z);
    final a2 = degree90.distanceFromDotPow3D(last);
    final b2 = degree90.distanceFromDotPow3D(first);
    final c2 = first.distanceFromDotPow3D(last);
    final degreeRadian = acos((b2 + c2 - a2) / (2 * sqrt(b2) * sqrt(c2)));
    degreeBeteenDots = degreeRadian * 180 / pi;
  }
}
