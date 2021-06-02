import 'package:gamr/database/points.dart';
import 'package:gamr/database/projects.dart';
import 'package:hive/hive.dart';

class DB {
  static final DB _singleton = DB._internal();
  DB._internal() {
    init();
  }
  late Box<Project> projects;
  late Box<DBPoint> points;

  factory DB() {
    return _singleton;
  }
  init() async {
    projects = await Hive.openBox<Project>('projects');
    points = await Hive.openBox<DBPoint>('points');
  }

  addProject(String name) async {
    projects.add(Project(name));
  }

  deleteProject(int key) async {
    projects.delete(key);
  }

  Future<Map<dynamic, Project>> getAllProject() async {
    var allProjects = projects.toMap();
    return allProjects;
  }

  updateProject(int key, String name) {
    var project = projects.get(key);
    project!.name = name;
  }

  updateDot(int dotKey, DBPoint point) {
    this.points.put(dotKey, point);
  }

  deleteDot(int dotKey) {
    this.points.delete(dotKey);
  }

  addDot(int projectId, DBPoint point) {
    this.points.add(point);
    var project = this.projects.get(projectId);
    if (project != null) {
      if (project.points.isEmpty) {
        project.points = HiveList(points);
      }
      project.points.add(point);
    }
  }
}
