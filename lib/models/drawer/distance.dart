import 'package:flutter/cupertino.dart';

class Distance extends Offset {
  Distance(double dx, double dy, this.distance, this.isBottomShow)
      : super(dx, dy);

  @override
  double distance;
  bool isBottomShow;
}
