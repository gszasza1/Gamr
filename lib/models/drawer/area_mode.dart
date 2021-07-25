import 'package:gamr/models/drawer/point.dart';

class AreaMode {
  List<Dot> selectedDots = [];
  List<Dot> selectedDrawDots = [];
  List<int> dotIndexes = [];
  double? calculatedArea;

  void addDotIndex(int index) {
    dotIndexes.add(index);
  }

  void addDot(Dot selectedDot, Dot selectedDrawDot) {
    selectedDots.add(selectedDot);
    selectedDrawDots.add(selectedDrawDot);
  }

  bool get havePoint {
    return !(selectedDots.isEmpty && dotIndexes.isEmpty);
  }

  void reset() {
    selectedDots = [];
    selectedDrawDots = [];
    dotIndexes = [];
    calculatedArea = null;
  }

  void resetDrawable() {
    selectedDrawDots = [];
  }

  void calculateArea() {
    double area = 0;
    int j = selectedDots.length - 1;
    final int n = selectedDots.length;
    for (var i = 0; i < n; i++) {
      area += (selectedDots[j].dx + selectedDots[i].dx) *
          (selectedDots[j].dy - selectedDots[i].dy);
      j = i;
    }
    calculatedArea = (area / 2.0).abs();
  }
}
