import 'package:flutter/material.dart';

import 'custom-painter.dart';
import 'test-data.dart';

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
  double currentYOffset = 0;
  List<Offset> allDots = testDots;
  TextEditingController xCoordRText = new TextEditingController(text: '');
  TextEditingController yCoordRText = new TextEditingController(text: '');
  bool showCoords = true;
  bool onlyPoints = false;
  bool showYAxis = true;
  bool showMedian = true;
  bool showTotalDegree = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('Reset positions'),
                onTap: () {
                  setState(() {
                    _sliderX = 10;
                    _sliderY = 10;
                    localpositon = null;
                    currentXOffset = 0;
                    currentYOffset = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Clear canvas'),
                onTap: () {
                  setState(() {
                    allDots = [];
                    xCoordRText.clear();
                    yCoordRText.clear();
                  });
                  Navigator.pop(context);
                },
              ),
              CheckboxListTile(
                title: const Text("Show coords"),
                value: showCoords,
                onChanged: (bool? value) {
                  setState(() {
                    showCoords = !showCoords;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Only points"),
                value: onlyPoints,
                onChanged: (bool? value) {
                  setState(() {
                    onlyPoints = !onlyPoints;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Show Y Axis"),
                value: showYAxis,
                onChanged: (bool? value) {
                  setState(() {
                    showYAxis = !showYAxis;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Show median"),
                value: showMedian,
                onChanged: (bool? value) {
                  setState(() {
                    showMedian = !showMedian;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Show total degree"),
                value: showTotalDegree,
                onChanged: (bool? value) {
                  setState(() {
                    showTotalDegree = !showTotalDegree;
                  });
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTapUp: (x) => {
                    setState(() {
                      localpositon = x.localPosition;
                    })
                  },
                  onPanEnd: (x) => {
                    setState(() {
                      currentXOffset = initMove != null && movedMove != null
                          ? initMove!.dx - movedMove!.dx + currentXOffset
                          : currentXOffset;
                      currentYOffset = initMove != null && movedMove != null
                          ? initMove!.dy - movedMove!.dy + currentYOffset
                          : currentYOffset;

                      initMove = null;
                    })
                  },
                  onPanStart: (x) => {
                    setState(() {
                      localpositon = null;
                      if (initMove == null) {
                        initMove = x.localPosition;
                      }
                    })
                  },
                  onPanUpdate: (x) => {
                    setState(() {
                      movedMove = x.localPosition;
                    })
                  },
                  child: CustomPaint(
                    painter: OpenPainter(
                      showTotalDegree: this.showTotalDegree,
                      showMedian: this.showMedian,
                      showYAxis: this.showYAxis,
                      onlyPoints: this.onlyPoints,
                      showCoords: this.showCoords,
                      paramPoints: allDots,
                      sliderX: this._sliderX,
                      sliderY: this._sliderY,
                      paramPoint: this.localpositon,
                      offsetX: initMove != null && movedMove != null
                          ? initMove!.dx - movedMove!.dx + currentXOffset
                          : currentXOffset,
                      offsetY: initMove != null && movedMove != null
                          ? initMove!.dy - movedMove!.dy + currentYOffset
                          : currentYOffset,
                    ),
                  ),
                ),
              ),
            ),
            Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Slider(
                      value: _sliderX,
                      min: 1,
                      max: 100,
                      label: "X: $_sliderX",
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
                       label: "X: $_sliderY",
                      onChanged: (double value) {
                        setState(() {
                          _sliderY = value;
                        });
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: ListView(
                                shrinkWrap: true,
                                children: allDots.map((e) {
                                  return Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 20,
                                            left: 10,
                                            right: 10,
                                            top: 20),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xfffff3f3f3)),
                                        )),
                                        child: Text(e.dx.toStringAsFixed(2)),
                                      ),
                                      Text(e.dy.toStringAsFixed(2)),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        tooltip: 'Delete',
                                        onPressed: () {
                                          setState(() {
                                            localpositon = null;
                                            allDots.remove(e);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: xCoordRText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'X',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: yCoordRText,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(), labelText: 'Y'),
                            ),
                          ),
                          TextButton(
                            child: Text("Add"),
                            onPressed: () => {
                              setState(() {
                                var parsedX =
                                    double.tryParse(xCoordRText.text) ?? 0;
                                if (!allDots
                                    .any((element) => element.dx == parsedX)) {
                                  allDots.add(Offset(parsedX,
                                      double.tryParse(yCoordRText.text) ?? 0));
                                  allDots.sort((a, b) => a.dx == b.dx
                                      ? 0
                                      : a.dx > b.dx
                                          ? 1
                                          : -1);
                                  xCoordRText.clear();
                                  yCoordRText.clear();
                                }
                              })
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),),
          ],
        ),
      ),
    );
  }
}
