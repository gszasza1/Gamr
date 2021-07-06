import 'package:flutter/material.dart';
import 'package:gamr/components/add-distance-points.dart';
import 'package:gamr/components/area-details-popup.dart';
import 'package:gamr/components/details-popup.dart';
import 'package:gamr/components/add-edit-popup.dart';
import 'package:gamr/components/general-info-dots.dart';
import 'package:gamr/components/list-item.dart';
import 'package:gamr/components/save-file-options.dart';
import 'package:gamr/components/set-divider-distance-popup.dart';
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
    options.showYAxis = prefs.getBool("showYAxis") ?? false;
    options.showMedian = prefs.getBool("showMedian") ?? false;
    options.showTotalDegree = prefs.getBool("showTotalDegree") ?? false;
    options.showNumber = prefs.getBool("showNumber") ?? false;
    options.show2Ddistance = prefs.getBool("show2Ddistance") ?? false;
    options.show3Ddistance = prefs.getBool("show3Ddistance") ?? false;
    options.showHeightVariation = prefs.getBool("show3Ddistance") ?? false;
    options.areaMode = prefs.getBool("areaMode") ?? false;
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
    xCoordRText.dispose();
    yCoordRText.dispose();
    zCoordRText.dispose();
  }

  Future<void> initializeProjectName() async {
    this.projectName = await DBService().getProjectName(widget.projectId);
  }

  Future<void> initializeDots() async {
    final dbDotList = await DBService().getProjectDots(widget.projectId);
    final transformedDots = dbDotList
        .map((e) => Dot.dzParameter(e.x, e.y, e.z,
            id: e.id, name: e.name, rank: e.rank))
        .toList();
    setState(() {
      dotList.addMultipleDots(transformedDots);
      this.resetPosition();
    });
  }

  resetPosition() {
    this.dotList.reset();
    this.initMove = null;
    localpositon = null;
    this.dotList.setNewFixOffset();
  }

  Future<void> addPoint(Dot dot) async {
    if (!dotList.allDots.any((element) =>
        element.x == dot.x && element.y == dot.y && element.z == dot.z)) {
      var newId = await DBService().addDot(
          widget.projectId,
          DBPoint(
              x: dot.x, y: dot.y, z: dot.z, name: dot.name, rank: dot.rank));
      dotList.addDot(Dot.dzParameter(dot.x, dot.y, dot.z,
          id: newId, name: dot.name, rank: dot.rank));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Létezik ilyen pont"),
        ),
      );
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

  onTapUp(TapUpDetails x) {
    setState(() {
      localpositon = Dot.offsetToDot(x.localPosition);
      if (localpositon != null) {
        if (options.twoDotMode) {
          this.dotList.selectDotForDivider(localpositon!);
        } else if (options.areaMode) {
          this.dotList.selectDotForAreaCalculation(localpositon!);
        } else {
          this.dotList.calculateOnDrawPointList(localpositon!);
        }
      }
    });
  }

  onScaleEnd(ScaleEndDetails x) {
    setState(() {
      initMove = null;
      this.dotList.isCanvasMoving = false;
      this.dotList.setNewFixOffset();
      if (this.dotList.twoDotMode.dividerDistance != null) {
        this.dotList.setDividerBetweenSelectedPoints2D();
      }
      this.dotList.refreshDrawArea();
    });
  }

  onScaleStart(ScaleStartDetails x) {
    setState(() {
      this.dotList.isCanvasMoving = true;
      this.dotList.twoDotMode.resetPoints();
      this.dotList.areaMode.resetDrawable();
      localpositon = null;
      initMove = x.localFocalPoint;
      this.dotList.resetSelectedPoint();
    });
  }

  onScaleUpdate(ScaleUpdateDetails x) {
    setState(() {
      if (initMove != null) {
        this.dotList.updateOffset(initMove!.dx - x.localFocalPoint.dx,
            initMove!.dy - x.localFocalPoint.dy, x.scale);
      }
    });
  }

  addDistanceDots() {
    setState(() {
      var maxRank = 0;
      this.dotList.allDots.forEach((element) {
        if (element.rank > maxRank) {
          maxRank = element.rank;
        }
      });
      final distanceDots = this.dotList.twoDotMode.distanceDots;
      for (var i = 0; i < distanceDots.length; i++) {
        distanceDots[i].rank = maxRank + i + 1;
        this.addPoint(distanceDots[i]);
      }
    });
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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddEditPopup(
                      save: (e) {
                        this.addPoint(e);
                      },
                      dot: Dot.dzParameter(0, 0, 0),
                      options: this
                          .dotList
                          .allDots
                          .map((e) => e.name)
                          .toSet()
                          .toList(),
                      isEdit: false);
                });
          },
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('Pozíciók visszaállítása'),
                onTap: () {
                  setState(() {
                    this.resetPosition();
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
                title: const Text("Hossz mutatása (2D)"),
                value: options.show2Ddistance,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("show2Ddistance", !options.show2Ddistance);
                    options.show2Ddistance = !options.show2Ddistance;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Hossz mutatása (3D)"),
                value: options.show3Ddistance,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool("show3Ddistance", !options.show3Ddistance);
                    options.show3Ddistance = !options.show3Ddistance;
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
                title: const Text("Z magasság különbség"),
                value: options.showTotalDegree,
                onChanged: (bool? value) {
                  setState(() {
                    prefs.setBool(
                        "showHeightVariation", !options.showHeightVariation);
                    options.showHeightVariation = !options.showHeightVariation;
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
                    this.resetPosition();
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
                    this.resetPosition();
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
                    this.resetPosition();
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
              child: Stack(children: [
                GestureDetector(
                  onTapUp: (x) {
                    onTapUp(x);
                  },
                  onScaleEnd: (x) {
                    onScaleEnd(x);
                  },
                  onScaleStart: (x) {
                    onScaleStart(x);
                  },
                  onScaleUpdate: (x) {
                    onScaleUpdate(x);
                  },
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: OpenPainter(
                        options: options,
                        dotList: dotList,
                        axis: currentAxis,
                        paramPoint: this.localpositon),
                  ),
                ),
                Positioned(
                  top: 20,
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
                Positioned(
                  top: 80,
                  right: 10,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          options.twoDotMode = !options.twoDotMode;
                          prefs.setBool("twoDotMode", options.twoDotMode);
                          if (options.areaMode) {
                            options.areaMode = false;
                            prefs.setBool("areaMode", options.areaMode);
                          }
                          if (!options.twoDotMode) {
                            this.dotList.twoDotMode.reset();
                          }
                        });
                      },
                      child: Ink(
                        height: 35,
                        width: 35,
                        decoration: ShapeDecoration(
                          color: options.twoDotMode
                              ? Colors.deepOrange
                              : Colors.lightBlue,
                          shape: CircleBorder(),
                        ),
                        child: const Icon(
                          Icons.horizontal_distribute,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                if (this.dotList.twoDotMode.isFull)
                  Positioned(
                    top: 130,
                    right: 10,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DividerDistancePopup(
                                    distance: this
                                            .dotList
                                            .twoDotMode
                                            .dividerDistance ??
                                        0,
                                    save: (e) {
                                      this
                                          .dotList
                                          .setDividerDistance(double.parse(e));
                                      this
                                          .dotList
                                          .setDividerBetweenSelectedPoints2D();
                                    });
                              });
                        },
                        child: Ink(
                          height: 35,
                          width: 35,
                          decoration: ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.open_in_full,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!options.twoDotMode)
                  Positioned(
                    top: 130,
                    right: 10,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            options.areaMode = !options.areaMode;
                            prefs.setBool("areaMode", options.areaMode);
                            if (!options.areaMode) {
                              this.dotList.areaMode.reset();
                              options.twoDotMode = false;
                              prefs.setBool("twoDotMode", options.twoDotMode);
                            }
                          });
                        },
                        child: Ink(
                          height: 35,
                          width: 35,
                          decoration: ShapeDecoration(
                            color: options.areaMode
                                ? Colors.deepOrange
                                : Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: Icon(Icons.crop_square, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                if (!options.twoDotMode &&
                    this.dotList.areaMode.calculatedArea != null)
                  Positioned(
                    top: 180,
                    right: 10,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AreaDetailsPopup(
                                    totalArea:
                                        this.dotList.areaMode.calculatedArea!,
                                    totalDots: this
                                        .dotList
                                        .areaMode
                                        .dotIndexes
                                        .length);
                              });
                        },
                        child: Ink(
                          height: 35,
                          width: 35,
                          decoration: ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: Icon(Icons.info, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                if (this.dotList.twoDotMode.isFull)
                  Positioned(
                    top: 180,
                    right: 10,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return GeneralInformationDots(
                                  degreeBeteenDots:
                                      this.dotList.twoDotMode.degreeBeteenDots,
                                  distance2D:
                                      this.dotList.twoDotMode.distance2D,
                                  distance3D:
                                      this.dotList.twoDotMode.distance3D,
                                  zHeightVariationBetweenDots: this
                                      .dotList
                                      .twoDotMode
                                      .zHeightVariationBetweenDots,
                                );
                              });
                        },
                        child: Ink(
                          height: 35,
                          width: 35,
                          decoration: ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (this.dotList.twoDotMode.isFull &&
                    this.dotList.twoDotMode.dividerDistance != null &&
                    this.dotList.twoDotMode.dividerDistance! > 0)
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddDistancePoints();
                              }).then((value) => {
                                if (value == true) {addDistanceDots()}
                              });
                        },
                        child: Ink(
                          height: 35,
                          width: 35,
                          decoration: ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.add_box,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ]),
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
                                      this.dotList.totalDegree,
                                      this
                                          .dotList
                                          .distances
                                          .map((x) => x.distance)
                                          .reduce((a, b) => a + b)),
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
                            height: MediaQuery.of(context).size.height * 0.3,
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
                                              return AddEditPopup(
                                                isEdit: true,
                                                options: this
                                                    .dotList
                                                    .allDots
                                                    .map((e) => e.name)
                                                    .toSet()
                                                    .toList(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
