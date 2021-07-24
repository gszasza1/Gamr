import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gamr/components/add_new_project.dart';
import 'package:gamr/components/import_project_popup.dart';
import 'package:gamr/components/project_list_item.dart';
import 'package:gamr/constant/project-list-menu.dart';
import 'package:gamr/models/database/points.dart';
import 'package:gamr/models/database/projects.dart';
import 'package:gamr/services/csv_service.dart';
import 'package:gamr/services/database_service.dart';
import 'package:gamr/services/json_service.dart';
import 'package:gamr/services/txt_service.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<Project> listProjects = [];

  @override
  void initState() {
    super.initState();
    getProjectList();
  }

  Future<void> getProjectList() async {
    final box = DBService().getAllProject();
    setState(() {
      listProjects = box;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(title: const Text("Projekt lista"), actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: PopupMenuButton(
            onSelected: (ProjectListMenu value) async {
              if (value == ProjectListMenu.import) {
                final FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['txt', 'json', 'csv'],
                );
                if (result != null && result.files.single.path != null) {
                  final file = result.files.first;
                  List<DBPoint>? fields;
                  try {
                    if (file.extension == "csv" && file.path != null) {
                      final File readFile = File(file.path!);
                      fields = await CSVService().createDotsFromCSV(readFile);
                    }
                    if (file.extension == "txt" && file.path != null) {
                      final File readFile = File(file.path!);
                      fields = await TxtService().createDotsFromTxt(readFile);
                    }
                    if (file.extension == "json") {
                      final File readFile = File(file.path!);
                      fields = await JsonService().createDotsFromJson(readFile);
                    }

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
                          await DBService()
                              .importProject(value as String, fields!);
                          await getProjectList();
                        }
                      });
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Sikertelen beolvasás. Baj van vaze?"),
                      ),
                    );
                  }
                } else {
                  // User canceled the picker
                }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: ProjectListMenu.import,
                  child: Text('Importálás'),
                ),
              ];
            },
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ),
      ]),
      body: listProjects.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                await getProjectList();
              },
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: listProjects.length,
                  itemBuilder: (ctx, idx) {
                    // List Item
                    return ProjectListItem(
                      refresh: () {
                        getProjectList();
                      },
                      project: listProjects[idx],
                    );
                  }),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
