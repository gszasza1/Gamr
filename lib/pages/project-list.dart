import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gamr/components/add-new-project.dart';
import 'package:gamr/components/import-project-popup.dart';
import 'package:gamr/components/project-list-item.dart';
import 'package:gamr/constant/project-list-menu.dart';
import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/database/projects.dart';
import 'package:gamr/services/csv-service.dart';
import 'package:gamr/services/database-service.dart';

class ProjectList extends StatefulWidget {
  ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<Project> listProjects = [];

  Future<void> getProjectList() async {
    final box = DBService().getAllProject();
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
        appBar: AppBar(title: Text("Projekt lista"), actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: PopupMenuButton(
              onSelected: (ProjectListMenu value) async {
                if (value == ProjectListMenu.import) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['txt', 'json', 'csv'],
                  );
                  if (result != null && result.files.single.path != null) {
                    var file = result.files.first;
                    List<DBPoint>? fields;
                    if (file.extension == "csv" && file.path != null) {
                      File readFile = File(file.path!);
                      fields = await CSVService().createDotsFromCSV(readFile);
                    }
                    if (file.extension == "txt") {}
                    if (file.extension == "json") {}

                    if (fields != null) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImportPopup(
                              projectName: file.name,
                              dotList: fields!,
                            );
                          }).then((value) async {
                        if (value.runtimeType == String) {
                          await DBService().importProject(value, fields!);
                          await this.getProjectList();
                        }
                      });
                    }
                  } else {
                    // User canceled the picker
                  }
                }
              },
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: ProjectListMenu.import,
                    child: Text('Importálás'),
                  ),
                ];
              },
            ),
          ),
        ]),
        body: listProjects.length != 0
            ? RefreshIndicator(
                onRefresh: () async {
                  await this.getProjectList();
                },
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: listProjects.length,
                    itemBuilder: (ctx, idx) {
                      // List Item
                      return ProjectListItem(project: listProjects[idx]);
                    }),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
