import 'package:flutter/material.dart';
import 'package:gamr/components/add-new-project.dart';
import 'package:gamr/components/project-list-item.dart';
import 'package:gamr/database/projects.dart';
import 'package:gamr/method/project-method.dart';

class ProjectList extends StatefulWidget {
  ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<Project> listProjects = [];

  Future<void> getProjectList() async {
    final box = DB().getAllProject();
    setState(() {
      listProjects = box;
    });
  }

  @override
  void initState() {
    super.initState();
    getProjectList();
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddNewProjectPopup(
                        refreshList: () => {getProjectList()});
                  });
            },
          ),
        ),
        // floatingActionButton: IconButton(
        //   icon: Icon(Icons.ac_unit),
        //   onPressed: () => {getProjectList()},
        // ),
        appBar: AppBar(title: Text("Projekt lista")),
        body: SizedBox(
          height: MediaQuery.of(context).size.height - 50,
          child: Column(children: [
            SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                children: listProjects
                    .map((e) => ProjectListItem(project: e))
                    .toList(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
