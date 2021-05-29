import 'package:flutter/material.dart';
import 'package:gamr/components/edit-popup.dart';
import 'package:gamr/components/list-item.dart';
import 'package:gamr/dot-list.dart';
import 'package:gamr/options.dart';
import 'package:gamr/point.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String currentAxis = "XY";
  late SharedPreferences prefs;
  DotList dotList = DotList();
  TextEditingController xCoordRText = TextEditingController(text: '');
  TextEditingController yCoordRText = TextEditingController(text: '');
  TextEditingController zCoordRText = TextEditingController(text: '');
  GamrOptions options = GamrOptions();

  Future getInitialPref() async {
    prefs = await SharedPreferences.getInstance();
    options.showCoords = prefs.getBool("showCoords") ?? true;
    options.onlyPoints = prefs.getBool("onlyPoints") ?? false;
    options.showYAxis = prefs.getBool("showYAxis") ?? true;
    options.showMedian = prefs.getBool("showMedian") ?? true;
    options.showTotalDegree = prefs.getBool("showTotalDegree") ?? true;
    options.showNumber = prefs.getBool("showNumber") ?? true;
  }

  @override
  void initState() {
    super.initState();
    dotList.addMultipleDots(testDots);
    this.getInitialPref();
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
                    zCoordRText.clear();
                  });
                  Navigator.pop(context);
                },
              ),
              CheckboxListTile(
                title: const Text("Show coords"),
                value: options.showCoords,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showCoords", !options.showCoords);
                    options.showCoords = !options.showCoords;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Only points"),
                value: options.onlyPoints,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("onlyPoints", !options.onlyPoints);
                    options.onlyPoints = !options.onlyPoints;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Show Y Axis"),
                value: options.showYAxis,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showYAxis", !options.showYAxis);
                    options.showYAxis = !options.showYAxis;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Show median"),
                value: options.showMedian,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showMedian", !options.showMedian);
                    options.showMedian = !options.showMedian;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Show total degree"),
                value: options.showTotalDegree,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showTotalDegree", !options.showTotalDegree);
                    options.showTotalDegree = !options.showTotalDegree;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Show number"),
                value: options.showNumber,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showNumber", !options.showNumber);
                    options.showNumber = !options.showNumber;
                  });
                },
              ),
              const Divider(),
              RadioListTile(
                title: const Text('XZ'),
                value: "XZ",
                groupValue: currentAxis,
                onChanged: (String? value) {
                  setState(() {
                    currentAxis = value ?? "XZ";
                    this.dotList.updateMainAxis(currentAxis);
                  });
                },
              ),
              RadioListTile(
                title: const Text('YZ'),
                value: "YZ",
                groupValue: currentAxis,
                onChanged: (String? value) {
                  setState(() {
                    currentAxis = value ?? "YZ";
                    this.dotList.updateMainAxis(currentAxis);
                  });
                },
              ),
              RadioListTile(
                title: const Text('XY'),
                value: "XY",
                groupValue: currentAxis,
                onChanged: (String? value) {
                  setState(() {
                    currentAxis = value ?? "XY";
                    this.dotList.updateMainAxis(currentAxis);
                  });
                },
              ),
              const Divider(),
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
                  onScaleEnd: (x) => {
                    setState(() {
                      initMove = null;
                      this.dotList.setNewFixOffset();
                    })
                  },
                  onScaleStart: (x) => {
                    setState(() {
                      localpositon = null;
                      initMove = x.localFocalPoint;
                    })
                  },
                  onScaleUpdate: (x) => {
                    setState(() {
                      if (initMove != null) {
                        this.dotList.updateOffset(
                            initMove!.dx - x.localFocalPoint.dx,
                            initMove!.dy - x.localFocalPoint.dy,
                            x.scale);
                      }
                    })
                  },
                  child: CustomPaint(
                    painter: OpenPainter(
                        options: options,
                        dotList: dotList,
                        axis: currentAxis,
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
                              children:
                                  dotList.allDots.asMap().entries.map((entry) {
                                int idx = entry.key;
                                var value = entry.value;
                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xfffff3f3f3)),
                                    ),
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditPopup(
                                                dot: value,
                                                save: (x) => {
                                                  setState(() {
                                                    this
                                                        .dotList
                                                        .removeDot(value);
                                                    this.dotList.addDot(x);
                                                  })
                                                },
                                              );
                                            });
                                      },
                                      child: DotListItem(
                                        callback: () {
                                          setState(() {
                                            localpositon = null;
                                            dotList.removeDot(value);
                                          });
                                        },
                                        index: idx,
                                        value: value,
                                        key: Key(idx.toString()),
                                      )),
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
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: zCoordRText,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(), labelText: 'Z'),
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
                                dotList.addDot(Dot.dzParameter(
                                    parsedX,
                                    double.tryParse(yCoordRText.text) ?? 0,
                                    double.tryParse(zCoordRText.text) ?? 0));
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
