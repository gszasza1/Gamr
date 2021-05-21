import 'dart:ui';

class DotList {
  List<Offset> allDots = [];
  List<Offset> drawAbleDots = [];
  double totalDegree = 0;
  double averageY = 0;
  double averageDrawY = 0;
  Paint graphPaint = Paint();
  double minY = 0;
  double offsetX = 0;
  double offsetY = 0;
  double sliderX = 0;
  double sliderY = 0;

  void addDot(Offset point,
      {required double sliderY, required double sliderX}) {
    allDots.add(point);
    allDots.sort((a, b) => a.dx == b.dx
        ? 0
        : a.dx > b.dx
            ? 1
            : -1);

    calculateAverageY();
    recalculateDrawable();
  }

  void recalculateDrawable() {
    drawAbleDots = allDots
        .map((x) => Offset(x.dx * sliderX / 10, x.dy * sliderY / 10))
        .toList();
    drawAbleDots = drawAbleDots
        .map((x) => Offset(x.dx - drawAbleDots[0].dx + 5 - offsetX,
            -x.dy - minY + 10 - offsetY))
        .toList();
    this.minY = getMinY(drawAbleDots);
    calculateAverageDrawY();
  }

  void removeDot(int index) {
    allDots.removeAt(index);
    drawAbleDots.removeAt(index);
    calculateAverageY();
  }

  void clear() {
    allDots = [];
    drawAbleDots = [];
    totalDegree = 0;
    averageY = 0;
    averageDrawY = 0;
    minY = 0;
  }

  void calculateAverageY() {
    averageY = (this.allDots.map((m) => m.dy).reduce((a, b) => a + b) /
        this.allDots.length);
  }

  void calculateAverageDrawY() {
    averageDrawY = (this.drawAbleDots.map((m) => m.dy).reduce((a, b) => a + b) /
        this.drawAbleDots.length);
  }

  void updateOffset(double offsetX, double offsetY) {
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    recalculateDrawable();
  }

  void updateSlider(double sliderX, double sliderY) {
    this.sliderX = sliderX;
    this.sliderY = sliderY;
    recalculateDrawable();
  }

  double getMinY(List<Offset> newPoint) {
    double currentMinY = newPoint[0].dy;
    newPoint.forEach((element) {
      if (element.dy < currentMinY) {
        currentMinY = element.dy;
      }
    });
    return currentMinY;
  }
}
