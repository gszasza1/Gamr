import 'package:flutter/material.dart';

import 'custom-painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset? localpositon;
  double _sliderX = 10;
  double _sliderY = 10;
  Offset? initMove;
  Offset? movedMove;
  double currentXOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTapUp: (x) => {
                setState(() {
                  print(x.localPosition);
                  localpositon = x.localPosition;
                })
              },
              onLongPressEnd: (x) => {
                setState(() {
                  currentXOffset = initMove != null && movedMove != null
                      ? initMove!.dx - movedMove!.dx + currentXOffset
                      : currentXOffset;

                  initMove = null;
                })
              },
              onLongPressStart: (x) => {
                setState(() {
                  if (initMove == null) {
                    initMove = x.localPosition;
                  }
                })
              },
              onLongPressMoveUpdate: (x) => {
                setState(() {
                  movedMove = x.localPosition;
                })
              },
              child: CustomPaint(
                painter: OpenPainter(
                    sliderX: this._sliderX,
                    sliderY: this._sliderY,
                    paramPoint: this.localpositon,
                    offsetX: initMove != null && movedMove != null
                        ? initMove!.dx - movedMove!.dx + currentXOffset
                        : currentXOffset),
              ),
            ),
          ),
          Slider(
            value: _sliderX,
            min: 1,
            max: 100,
            label: _sliderX.toString(),
            onChanged: (double value) {
              setState(() {
                _sliderX = value;
              });
            },
          ),
          Slider(
            value: _sliderY,
            min: 1,
            max: 100,
            label: _sliderY.toString(),
            onChanged: (double value) {
              setState(() {
                _sliderY = value;
              });
            },
          )
        ],
      ),
    );
  }
}
