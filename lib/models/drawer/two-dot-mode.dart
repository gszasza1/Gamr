import 'dart:math';

import 'package:gamr/models/drawer/point.dart';

class TwoDotMode {
  List<int> selectedDotIndexes = [];
  List<Dot> selectedDots = [];

  double? dividerDistance;

  List<Dot> drawDistanceDots = [];
  List<Dot> distanceDots = [];

  /// MetaData between dots
  double distance3D = 0;
  double distance2D = 0;
  double degreeBeteenDots = 0;
  double zHeightVariationBetweenDots = 0;

  setDot(int index, Dot dot) {
    if (this.selectedDotIndexes.length < 2) {
      if (!this.selectedDotIndexes.contains(index)) {
        this.selectedDotIndexes.add(index);
        this.selectedDots.add(dot);
        if (this.selectedDots.length == 2) {
          this.calculate2DDistance();
          this.calculate3DDistance();
          this.calculateZHeightVariation();
          this.calculateDegree();
        }
      }
      return;
    } else {
      this.selectedDotIndexes = [index];
      this.selectedDots = [dot];
      this.drawDistanceDots = [];
      this.distanceDots = [];
    }
  }

  get isFull {
    return this.selectedDotIndexes.length == 2;
  }

  get havePoint {
    return this.selectedDots.length != 0;
  }

  reset() {
    this.selectedDotIndexes = [];
    this.drawDistanceDots = [];
    this.distanceDots = [];
    this.selectedDots = [];
    this.dividerDistance = null;
  }

  resetPoints() {
    this.drawDistanceDots = [];
    this.distanceDots = [];
  }

  calculate2DDistance() {
    this.distance2D =
        (this.selectedDots[0].distanceFromDot(this.selectedDots[1])).abs();
  }

  calculate3DDistance() {
    this.distance3D =
        (this.selectedDots[0].distanceFromDot3D(this.selectedDots[1])).abs();
  }

  calculateZHeightVariation() {
    this.zHeightVariationBetweenDots =
        (this.selectedDots[0].z - this.selectedDots[1].z).abs();
  }

  calculateDegree() {
    final first = this.selectedDots[0];
    final last = this.selectedDots[1];
    final degree90 = Dot.dzParameter(last.x, last.y, first.z);
    final a2 = degree90.distanceFromDotPow3D(last);
    final b2 = degree90.distanceFromDotPow3D(first);
    final c2 = first.distanceFromDotPow3D(last);
    final degreeRadian = acos((b2 + c2 - a2) / (2 * sqrt(b2) * sqrt(c2)));
    this.degreeBeteenDots = degreeRadian * 180 / pi;
  }
}
