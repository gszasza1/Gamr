import 'package:flutter/material.dart';
import 'package:gamr/components/add_distance_points.dart';
import 'package:gamr/components/area_details_popup.dart';
import 'package:gamr/components/details_popup.dart';
import 'package:gamr/components/add_edit_popup.dart';
import 'package:gamr/components/dot_info.dart';
import 'package:gamr/components/two_mode_info_dots.dart';
import 'package:gamr/components/list_item.dart';
import 'package:gamr/components/positioned_icon.dart';
import 'package:gamr/components/save_file_options.dart';
import 'package:gamr/components/set_divider_distance_popup.dart';
import 'package:gamr/constant/email_menu.dart';
import 'package:gamr/constant/popup_menu.dart';
import 'package:gamr/custom_painter.dart';
import 'package:gamr/config/options.dart';
import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/drawer/dot_list.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/services/csv_service.dart';
import 'package:gamr/services/database_service.dart';
import 'package:gamr/services/json_service.dart';
import 'package:gamr/services/txt_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({required this.projectId});
  final int projectId;
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
    initializeDots();
    initializeProjectName();
    getInitialPref();
  }

  @override
  void dispose() {
    super.dispose();
    dotList.clear();
    xCoordRText.dispose();
    yCoordRText.dispose();
    zCoordRText.dispose();
  }

  Future<void> initializeProjectName() async {
    projectName = await DBService().getProjectName(widget.projectId);
  }

  Future<void> initializeDots() async {
    final dbDotList = await DBService().getProjectDots(widget.projectId);
    final transformedDots = dbDotList
        .map((e) => Dot.dzParameter(e.x, e.y, e.z,
            id: e.id, name: e.name, rank: e.rank))
        .toList();
    setState(() {
      dotList.addMultipleDots(transformedDots);
      resetPosition();
    });
  }

  void resetPosition() {
    dotList.reset();
    initMove = null;
    localpositon = null;
    dotList.setNewFixOffset();
    if (options.twoDotMode) {
      dotList.generateNewDistances(false);
    }
    if (options.areaMode) {
      dotList.refreshDrawArea();
    }
  }

  Future<void> addPoint(Dot dot) async {
    if (!dotList.allDots.any((element) =>
        element.x == dot.x && element.y == dot.y && element.z == dot.z)) {
      final newId = await DBService().addDot(
          widget.projectId,
          DBPoint(
              x: dot.x, y: dot.y, z: dot.z, name: dot.name, rank: dot.rank));
      dotList.addDot(Dot.dzParameter(dot.x, dot.y, dot.z,
          id: newId, name: dot.name, rank: dot.rank));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Létezik ilyen pont"),
        ),
      );
    }
  }

  Future<void> updateDot(Dot value) async {
    DBService().updateDot(value);
    dotList.updateDot(value);
  }

  Future<void> deleteDot(Dot value) async {
    localpositon = null;
    dotList.removeDot(value);
    await DBService().deleteDot(widget.projectId, value.id);
  }

  void onTapUp(TapUpDetails x) {
    setState(() {
      localpositon = Dot.offsetToDot(x.localPosition);
      if (localpositon != null) {
        if (options.twoDotMode) {
          dotList.selectDotForDivider(localpositon!);
        } else if (options.areaMode) {
          dotList.selectDotForAreaCalculation(localpositon!);
        } else {
          dotList.calculateOnDrawPointList(localpositon!);
        }
      }
    });
  }

  void onLongPressStart(LongPressStartDetails x) {
    final selectedPoint = Dot.fromOffset(x.localPosition);
    final selectedDotIndex = dotList.nearestDotToSelected(selectedPoint);
    if (dotList.drawAbleDots[selectedDotIndex].distanceFromDot(selectedPoint) <
        10) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DotInfo(selectedDot: dotList.allDots[selectedDotIndex]);
          });
    }
  }

  void onScaleEnd(ScaleEndDetails x) {
    setState(() {
      initMove = null;
      dotList.isCanvasMoving = false;
      dotList.setNewFixOffset();
      if (dotList.twoDotMode.dividerMeasure != null) {
        dotList.decideDistanceMode();
      }
      dotList.refreshDrawArea();
    });
  }

  void onScaleStart(ScaleStartDetails x) {
    setState(() {
      dotList.isCanvasMoving = true;
      dotList.twoDotMode.resetPoints();
      dotList.areaMode.resetDrawable();
      localpositon = null;
      initMove = x.localFocalPoint;
      dotList.resetSelectedPoint();
    });
  }

  void onScaleUpdate(ScaleUpdateDetails x) {
    setState(() {
      if (initMove != null) {
        dotList.updateOffset(initMove!.dx - x.localFocalPoint.dx,
            initMove!.dy - x.localFocalPoint.dy, x.scale);
      }
    });
  }

  void addDistanceDots() {
    setState(() {
      var maxRank = 0;
      dotList.allDots.forEach((element) {
        if (element.rank > maxRank) {
          maxRank = element.rank;
        }
      });
      final distanceDots = dotList.twoDotMode.distanceDots;
      for (var i = 0; i < distanceDots.length; i++) {
        distanceDots[i].rank = maxRank + i + 1;
        addPoint(distanceDots[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddEditPopup(
                      save: (e) {
                        addPoint(e);
                      },
                      dot: Dot.dzParameter(0, 0, 0),
                      options:
                          dotList.allDots.map((e) => e.name).toSet().toList(),
                      isEdit: false);
                });
          },
          child: const Icon(Icons.add),
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
                    resetPosition();
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
                value: options.showHeightVariation,
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
                    dotList.updateMainAxis(currentAxis);
                    resetPosition();
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
                    dotList.updateMainAxis(currentAxis);
                    resetPosition();
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
                    dotList.updateMainAxis(currentAxis);
                    resetPosition();
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
              child: Stack(children: [
                GestureDetector(
                  onLongPressStart: (x) {
                    onLongPressStart(x);
                  },
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
                        options: options, dotList: dotList, axis: currentAxis),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      onSelected: (PopupMenu value) {
                        if (value == PopupMenu.backToMenu) {
                          Navigator.of(context).pop();
                        }
                        if (value == PopupMenu.sendEmail) {
                          Navigator.pushNamed(
                            context,
                            '/project/${widget.projectId}/email',
                          );
                        }
                        if (value == PopupMenu.saveFile) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SaveFilePopup();
                              }).then((value) {
                            if (value == EmailMenu.asJson) {
                              JsonService().createJsonfromDots(
                                  projectName: projectName,
                                  dots: dotList.allDots);
                            }

                            if (value == EmailMenu.asCsv) {
                              CSVService().createCSVfromDots(
                                  projectName: projectName,
                                  dots: dotList.allDots);
                            }
                            if (value == EmailMenu.asTxt) {
                              TxtService().createTxtfromDots(
                                  projectName: projectName,
                                  dots: dotList.allDots);
                            }
                          });
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: PopupMenu.backToMenu,
                            child: Text('Főmenübe'),
                          ),
                          const PopupMenuItem(
                            value: PopupMenu.sendEmail,
                            child: Text('Küldés e-mailben'),
                          ),
                          const PopupMenuItem(
                            value: PopupMenu.saveFile,
                            child: Text('Mentés fájlként'),
                          ),
                        ];
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
                    ),
                  ),
                ),
                PositionedIcon(
                  icon: Icons.horizontal_distribute,
                  top: 80,
                  right: 10,
                  color:
                      options.twoDotMode ? Colors.deepOrange : Colors.lightBlue,
                  onTap: () {
                    setState(() {
                      options.twoDotMode = !options.twoDotMode;
                      prefs.setBool("twoDotMode", options.twoDotMode);
                      options.areaMode = false;
                      prefs.setBool("areaMode", options.areaMode);
                      if (dotList.areaMode.havePoint) {
                        dotList.areaMode.reset();
                      }
                      if (!options.twoDotMode) {
                        dotList.twoDotMode.reset();
                      }
                    });
                  },
                ),
                PositionedIcon(
                  icon: Icons.crop_square,
                  top: 130,
                  right: 10,
                  color:
                      options.areaMode ? Colors.deepOrange : Colors.lightBlue,
                  onTap: () {
                    setState(() {
                      options.twoDotMode = false;
                      prefs.setBool("twoDotMode", options.twoDotMode);
                      options.areaMode = !options.areaMode;
                      prefs.setBool("areaMode", options.areaMode);
                      if (!options.areaMode) {
                        dotList.areaMode.reset();
                      }
                      if (dotList.twoDotMode.havePoint) {
                        dotList.twoDotMode.reset();
                      }
                    });
                  },
                ),
                if (!options.twoDotMode &&
                    dotList.areaMode.calculatedArea != null)
                  PositionedIcon(
                    icon: Icons.info,
                    bottom: 20,
                    right: 10,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AreaDetailsPopup(
                                totalArea: dotList.areaMode.calculatedArea!,
                                totalDots: dotList.areaMode.dotIndexes.length);
                          });
                    },
                  ),
                if (options.twoDotMode)
                  PositionedIcon(
                    icon: Icons.adjust,
                    bottom: 20,
                    right: 10,
                    color: dotList.twoDotMode.continueMode
                        ? Colors.deepOrange
                        : Colors.lightBlue,
                    onTap: () {
                      setState(() {
                        dotList.twoDotMode.continueMode =
                            !dotList.twoDotMode.continueMode;
                        dotList.decideDistanceMode();
                      });
                    },
                  ),
                if (dotList.twoDotMode.isFull)
                  PositionedIcon(
                    icon: Icons.info,
                    bottom: 20,
                    right: 55,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return GeneralInformationDots(
                              zHeightDegree: dotList.twoDotMode.zHeightDegree,
                              degreeBeteenDots:
                                  dotList.twoDotMode.degreeBeteenDots,
                              distance2D: dotList.twoDotMode.distance2D,
                              distance3D: dotList.twoDotMode.distance3D,
                              zHeightVariationBetweenDots: dotList
                                  .twoDotMode.zHeightVariationBetweenDots,
                            );
                          });
                    },
                  ),
                if (dotList.twoDotMode.isFull)
                  PositionedIcon(
                    icon: Icons.open_in_full,
                    bottom: 20,
                    right: 100,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DividerDistancePopup(
                                distance:
                                    dotList.twoDotMode.dividerMeasure ?? 0,
                                isEqualDistances:
                                    dotList.twoDotMode.isEqualDistances,
                                save: (distance, isEqualDistances) {
                                  dotList.twoDotMode.isEqualDistances =
                                      isEqualDistances;
                                  dotList.setDividerDistance(
                                      double.parse(distance));
                                  dotList.decideDistanceMode();
                                });
                          });
                    },
                  ),
                if (dotList.twoDotMode.isFull &&
                    dotList.twoDotMode.dividerMeasure != null &&
                    dotList.twoDotMode.dividerMeasure! > 0)
                  PositionedIcon(
                    icon: Icons.add_box,
                    bottom: 20,
                    right: 145,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AddDistancePoints();
                          }).then((value) => {
                            if (value == true) {addDistanceDots()}
                          });
                    },
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
                          value: dotList.sliderX,
                          min: 1,
                          divisions: 99,
                          max: 100,
                          label:
                              "X: ${(dotList.sliderX / 10).toStringAsFixed(1)}",
                          onChanged: (double value) {
                            setState(() {
                              dotList.updateSlider(sliderX: value);
                            });
                          },
                        ),
                        Slider(
                          value: dotList.sliderY,
                          min: 1,
                          divisions: 99,
                          max: 100,
                          label:
                              "Y: ${(dotList.sliderY / 10).toStringAsFixed(1)}",
                          onChanged: (double value) {
                            setState(() {
                              dotList.updateSlider(sliderY: value);
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
                                      dotList.averageY,
                                      dotList.allDots.length,
                                      dotList.totalDegree,
                                      dotList.distances
                                          .map((x) => x.distance)
                                          .reduce((a, b) => a + b)),
                                );
                              });
                        },
                      ),
                    ),
                  ]),
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ListView(
                              shrinkWrap: true,
                              children:
                                  dotList.allDots.asMap().entries.map((entry) {
                                final int idx = entry.key;
                                final value = entry.value;
                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Color(0xfff3f3f3)),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AddEditPopup(
                                              isEdit: true,
                                              options: dotList.allDots
                                                  .map((e) => e.name)
                                                  .toSet()
                                                  .toList(),
                                              dot: value,
                                              save: (x) => {
                                                setState(() {
                                                  updateDot(x);
                                                })
                                              },
                                            );
                                          });
                                    },
                                    child: DotListItem(
                                      callback: () {
                                        setState(() {
                                          deleteDot(value);
                                        });
                                      },
                                      value: value,
                                      key: Key(idx.toString()),
                                    ),
                                  ),
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
