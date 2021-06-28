import 'dart:io';

import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/database/projects.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:gamr/database/projects.dart';

class DBService {
  static final DBService _singleton = DBService._internal();
  late final Store store;
  factory DBService() {
    return _singleton;
  }

  DBService._internal();
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    print(dir.path + '/objectbox');
    store = Store(getObjectBoxModel(), directory: dir.path + '/objectbox');
  }

  void addProject(String name) {
    var box = store.box<Project>();
    box.put(Project(name));
  }

  deleteProject(int key) async {
    var points = store.box<DBPoint>();
    var projects = store.box<Project>();
    final query = points.query(DBPoint_.project.equals(key)).build();
    final removableDots = query.find();
    points.removeMany(removableDots.map((e) => e.id).toList());
    projects.remove(key);
  }

  List<Project> getAllProject() {
    var box = store.box<Project>();
    return box.getAll();
  }

  updateProject(Project pr) {
    var box = store.box<Project>();
    box.put(pr);
  }

  updateDot(Dot point) async {
    var box = store.box<DBPoint>();
    var dbPoint = box.get(point.id);
    if (dbPoint != null) {
      dbPoint.x = point.x;
      dbPoint.y = point.y;
      dbPoint.z = point.z;
      box.put(dbPoint);
    }
  }

  deleteDot(int projectId, int dotKey) async {
    var box = store.box<DBPoint>();
    var projects = store.box<Project>();
    var project = projects.get(projectId);
    if (project != null) {
      final dot = box.get(dotKey);
      project.points.remove(dot);
      box.remove(dotKey);
    }
  }

  Future<int> addDot(int projectId, DBPoint point) async {
    var box = store.box<DBPoint>();

    var newId = box.put(point);
    var projects = store.box<Project>();
    var project = projects.get(projectId);
    if (project != null) {
      project.points.add(point);
      projects.put(project);
    }
    return newId;
  }

  Future<List<DBPoint>> getProjectDots(int projectId) async {
    var projects = store.box<Project>();
    var project = projects.get(projectId);
    if (project != null) {
      return project.points.toList();
    } else {
      return [];
    }
  }

  Future<void> importProject(String projectName, List<DBPoint> dots) async {
    var projects = store.box<Project>();
    var projectId = projects.put(Project(projectName));
    dots.forEach((element) {
      this.addDot(projectId, element);
    });
  }

  Future<String> getProjectName(int projectId) async {
    var projects = store.box<Project>();
    var project = projects.get(projectId);
    if (project != null) {
      return project.name;
    } else {
      return "Nincs találat";
    }
  }
}
