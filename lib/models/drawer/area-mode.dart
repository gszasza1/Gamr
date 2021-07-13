import 'package:gamr/models/drawer/point.dart';

class AreaMode {
  List<Dot> selectedDots = [];
  List<Dot> selectedDrawDots = [];
  List<int> dotIndexes = [];
  double? calculatedArea;

  addDotIndex(int index) {
    this.dotIndexes.add(index);
  }

  addDot(Dot selectedDot, Dot selectedDrawDot) {
    this.selectedDots.add(selectedDot);
    this.selectedDrawDots.add(selectedDrawDot);
  }

  get havePoint {
    return !(selectedDots.length == 0 && dotIndexes.length == 0);
  }

  reset() {
    this.selectedDots = [];
    this.selectedDrawDots = [];
    this.dotIndexes = [];
    this.calculatedArea = null;
  }

  resetDrawable() {
    this.selectedDrawDots = [];
  }

  calculateArea() {
    double area = 0;
    int j = selectedDots.length - 1;
    int n = selectedDots.length;
    for (var i = 0; i < n; i++) {
      area += (selectedDots[j].dx + selectedDots[i].dx) *
          (selectedDots[j].dy - selectedDots[i].dy);
      j = i;
    }
    calculatedArea = (area / 2.0).abs();
  }
}
