import 'package:flutter/material.dart';
import 'package:gamr/components/project-list-item.dart';
import 'package:gamr/database/projects.dart';
import 'package:gamr/method/project-method.dart';

class ProjectList extends StatefulWidget {
  ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  Map<dynamic, Project> listProjects = Map();
  Future<void> getProjectList() async {
    final box = await DB().getAllProject();
    setState(() {
      listProjects = box;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButton: Ink(
          decoration: const ShapeDecoration(
            color: Colors.lightBlue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
        appBar: AppBar(title: Text("Projekt lista")),
        body: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            children: listProjects.entries
                .map((e) => ProjectListItem(project: e.value, projectId: e.key))
                .toList(),
          ),
        ),
      ),
    );
  }
}
