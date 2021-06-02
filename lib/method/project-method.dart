import 'dart:io';

import 'package:gamr/database/points.dart';
import 'package:gamr/database/projects.dart';
import 'package:gamr/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:gamr/database/projects.dart';

class DB {
  static final DB _singleton = DB._internal();
  late final Store store;
  factory DB() {
    return _singleton;
  }

  DB._internal();
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
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

  updateProject(int key, Project pr) {
    var box = store.box<Project>();
    box.put(pr);
  }

  updateDot(int dotKey, DBPoint point) async {
    var box = store.box<DBPoint>();
    box.put(point);
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

  addDot(int projectId, DBPoint point) async {
    var box = store.box<DBPoint>();
    box.put(point);
    var projects = store.box<Project>();
    var project = projects.get(projectId);
    if (project != null) {
      project.points.add(point);
      projects.put(project);
    }
  }
}
