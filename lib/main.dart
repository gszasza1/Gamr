import 'package:flutter/material.dart';
import 'package:gamr/dot-list.dart';
import 'package:gamr/point.dart';

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
  Dot? localpositon;

  Offset? initMove;

  DotList dotList = DotList();
  TextEditingController xCoordRText = new TextEditingController(text: '');
  TextEditingController yCoordRText = new TextEditingController(text: '');
  bool showCoords = true;
  bool onlyPoints = false;
  bool showYAxis = true;
  bool showMedian = true;
  bool showTotalDegree = true;

  @override
  void initState() {
    super.initState();
   // dotList.addMultipleDots(testDots);
  }

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
                    this.dotList.reset();
                    this.initMove = null;
                    localpositon = null;
                    this.dotList.setNewFixOffset();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Clear canvas'),
                onTap: () {
                  setState(() {
                    dotList.clear();
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
                      localpositon = Dot.offsetToDot(x.localPosition);
                    })
                  },
                  onPanEnd: (x) => {
                    setState(() {
                      initMove = null;
                      this.dotList.setNewFixOffset();
                    })
                  },
                  onPanStart: (x) => {
                    setState(() {
                      localpositon = null;
                      initMove = x.localPosition;
                    })
                  },
                  onPanUpdate: (x) => {
                    setState(() {
                      if (initMove != null) {

                        this.dotList.updateOffset(
                            initMove!.dx -
                                x.localPosition.dx,
                            initMove!.dy -
                                x.localPosition.dy);
                      }
                    })
                  },
                  child: CustomPaint(
                    painter: OpenPainter(
                        showTotalDegree: this.showTotalDegree,
                        showMedian: this.showMedian,
                        showYAxis: this.showYAxis,
                        onlyPoints: this.onlyPoints,
                        showCoords: this.showCoords,
                        dotList: dotList,
                        paramPoint: this.localpositon),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Slider(
                    value: this.dotList.sliderX,
                    min: 1,
                    max: 100,
                    label: "X: ${this.dotList.sliderX}",
                    onChanged: (double value) {
                      setState(() {
                        this.dotList.updateSlider(sliderX: value);
                      });
                    },
                  ),
                  Slider(
                    value: this.dotList.sliderY,
                    min: 1,
                    max: 100,
                    label: "Y: ${this.dotList.sliderY}",
                    onChanged: (double value) {
                      setState(() {
                        this.dotList.updateSlider(sliderY: value);
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
                              children: dotList.allDots.map((e) {
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
                                          dotList.removeDot(e);
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
                              if (!dotList.allDots
                                  .any((element) => element.dx == parsedX)) {
                                dotList.allDots.add(Dot(parsedX,
                                    double.tryParse(yCoordRText.text) ?? 0));
                                dotList.allDots.sort((a, b) => a.dx == b.dx
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
