import 'package:gamr/models/drawer/point.dart';

class TwoDotMode {
  List<int> selectedDotIndexes = [];

  double? dividerDistance;

  List<Dot> drawDistanceDots = [];
  List<Dot> distanceDots = [];
  setDot(int index) {
    if (this.selectedDotIndexes.length < 2) {
      if (!this.selectedDotIndexes.contains(index)) {
        this.selectedDotIndexes.add(index);
      }
      return;
    } else {
      this.selectedDotIndexes = [index];
      this.drawDistanceDots = [];
      this.distanceDots = [];
    }
  }

  get isFull {
    return this.selectedDotIndexes.length == 2;
  }

  reset() {
    this.selectedDotIndexes = [];
    this.drawDistanceDots = [];
    this.distanceDots = [];
  }

  resetPoints() {
    this.drawDistanceDots = [];
    this.distanceDots = [];
  }
}
