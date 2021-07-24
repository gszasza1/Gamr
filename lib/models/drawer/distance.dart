import 'package:flutter/cupertino.dart';

class Distance extends Offset {

  @override
  double distance;
  bool isBottomShow;
  
  Distance(double dx, double dy, this.distance, this.isBottomShow)
      : super(dx, dy);
}
