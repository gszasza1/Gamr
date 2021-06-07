import 'package:flutter/material.dart';
import 'package:gamr/components/details-popup.dart';
import 'package:gamr/components/edit-popup.dart';
import 'package:gamr/components/list-item.dart';
import 'package:gamr/components/save-file-options.dart';
import 'package:gamr/constant/email-menu.dart';
import 'package:gamr/constant/popup-menu.dart';
import 'package:gamr/custom-painter.dart';
import 'package:gamr/config/options.dart';
import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/drawer/dot-list.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/services/csv-service.dart';
import 'package:gamr/services/database-service.dart';
import 'package:gamr/services/json-service.dart';
import 'package:gamr/services/txt-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  final int projectId;
  DrawerPage({required this.projectId});
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  Dot? localpositon;

  Offset? initMove;
  String currentAxis = "XY";
  late SharedPreferences prefs;
  DotList dotList = DotList();
  TextEditingController xCoordRText = TextEditingController(text: '');
  TextEditingController yCoordRText = TextEditingController(text: '');
  TextEditingController zCoordRText = TextEditingController(text: '');
  GamrOptions options = GamrOptions();
  late final String projectName;
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
    //  dotList.addMultipleDots(testDots);
    this.initializeDots();
    this.initializeProjectName();
    this.getInitialPref();
  }

  @override
  void dispose() {
    super.dispose();
    this.dotList.clear();
  }

  Future<void> initializeProjectName() async {
    this.projectName = await DBService().getProjectName(widget.projectId);
  }

  Future<void> initializeDots() async {
    final dbDotList = await DBService().getProjectDots(widget.projectId);
    final transformedDots =
        dbDotList.map((e) => Dot.dzParameter(e.x, e.y, e.z, id: e.id)).toList();
    setState(() {
      dotList.addMultipleDots(transformedDots);
    });
  }

  Future<void> addPoint() async {
    var parsedX = double.tryParse(xCoordRText.text) ?? 0;
    var parsedY = double.tryParse(yCoordRText.text) ?? 0;
    var parsedZ = double.tryParse(zCoordRText.text) ?? 0;
    if (!dotList.allDots.any((element) =>
        element.x == parsedX && element.y == parsedY && element.z == parsedZ)) {
      var newId = await DBService().addDot(
          widget.projectId, DBPoint(x: parsedX, y: parsedY, z: parsedZ));
      dotList.addDot(Dot.dzParameter(parsedX, parsedY, parsedZ, id: newId));
      xCoordRText.clear();
      yCoordRText.clear();
      zCoordRText.clear();
    }
  }

  Future<void> updateDot(Dot value) async {
    DBService().updateDot(value);
    this.dotList.updateDot(value);
  }

  Future<void> deleteDot(Dot value) async {
    localpositon = null;
    dotList.removeDot(value);
    await DBService().deleteDot(widget.projectId, value.id);
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
                title: Text('Pozíciók visszaállítása'),
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
              CheckboxListTile(
                title: const Text("Koordináták mutatása"),
                value: options.showCoords,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showCoords", !options.showCoords);
                    options.showCoords = !options.showCoords;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Csak pontok"),
                value: options.onlyPoints,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("onlyPoints", !options.onlyPoints);
                    options.onlyPoints = !options.onlyPoints;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Tengerszint mutatása"),
                value: options.showYAxis,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showYAxis", !options.showYAxis);
                    options.showYAxis = !options.showYAxis;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Átlagos magasság"),
                value: options.showMedian,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showMedian", !options.showMedian);
                    options.showMedian = !options.showMedian;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Átlagos meredekség"),
                value: options.showTotalDegree,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("showTotalDegree", !options.showTotalDegree);
                    options.showTotalDegree = !options.showTotalDegree;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Sorszám mutatása"),
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
        body: Stack(
          children: <Widget>[
            Column(
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
                      Row(children: [
                        Expanded(
                            child: Column(
                          children: [
                            Slider(
                              value: this.dotList.sliderX,
                              min: 1,
                              divisions: 99,
                              max: 100,
                              label:
                                  "X: ${(this.dotList.sliderX / 10).toStringAsFixed(1)}",
                              onChanged: (double value) {
                                setState(() {
                                  this.dotList.updateSlider(sliderX: value);
                                });
                              },
                            ),
                            Slider(
                              value: this.dotList.sliderY,
                              min: 1,
                              divisions: 99,
                              max: 100,
                              label:
                                  "Y: ${(this.dotList.sliderY / 10).toStringAsFixed(1)}",
                              onChanged: (double value) {
                                setState(() {
                                  this.dotList.updateSlider(sliderY: value);
                                });
                              },
                            )
                          ],
                        )),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.black,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            tooltip: 'Részletek',
                            icon: const Icon(Icons.toc),
                            color: Colors.black,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DetailsPopup(
                                      details: Details(
                                          this.dotList.averageY,
                                          this.dotList.allDots.length,
                                          this.dotList.totalDegree),
                                    );
                                  });
                            },
                          ),
                        ),
                      ]),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: dotList.allDots
                                      .asMap()
                                      .entries
                                      .map((entry) {
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
                                                builder:
                                                    (BuildContext context) {
                                                  return EditPopup(
                                                    dot: value,
                                                    save: (x) => {
                                                      setState(() {
                                                        this.updateDot(x);
                                                      })
                                                    },
                                                  );
                                                });
                                          },
                                          child: DotListItem(
                                            callback: () {
                                              setState(() {
                                                this.deleteDot(value);
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
                                    border: OutlineInputBorder(),
                                    labelText: 'Y'),
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
                                    border: OutlineInputBorder(),
                                    labelText: 'Z'),
                              ),
                            ),
                            TextButton(
                              child: Text("Új"),
                              onPressed: () => {
                                setState(() {
                                  this.addPoint();
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
            Positioned.fill(
              top: 10,
              right: 10,
              child: Align(
                alignment: Alignment.topRight,
                child: PopupMenuButton(
                  onSelected: (PopupMenu value) {
                    if (value == PopupMenu.back_to_menu) {
                      Navigator.of(context).pop();
                    }
                    if (value == PopupMenu.send_email) {
                      Navigator.pushNamed(
                        context,
                        '/project/${widget.projectId}/email',
                      );
                    }
                    if (value == PopupMenu.save_file) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SaveFilePopup();
                          }).then((value) {
                        if (value == EmailMenu.as_json) {
                          JsonService().createJsonfromDots(
                              projectName: projectName,
                              dots: this.dotList.allDots);
                        }

                        if (value == EmailMenu.as_csv) {
                          CSVService().createCSVfromDots(
                              projectName: projectName,
                              dots: this.dotList.allDots);
                        }
                        if (value == EmailMenu.as_txt) {
                          TxtService().createTxtfromDots(
                              projectName: projectName,
                              dots: this.dotList.allDots);
                        }
                      });
                    }
                  },
                  child: Ink(
                    height: 35,
                    width: 35,
                    decoration: const ShapeDecoration(
                      color: Colors.lightBlue,
                      shape: CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: PopupMenu.back_to_menu,
                        child: Text('Főmenübe'),
                      ),
                      PopupMenuItem(
                        value: PopupMenu.send_email,
                        child: Text('Küldés e-mailben'),
                      ),
                      PopupMenuItem(
                        value: PopupMenu.save_file,
                        child: Text('Mentés fájlként'),
                      ),
                    ];
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
