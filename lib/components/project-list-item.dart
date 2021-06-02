import 'package:flutter/material.dart';
import 'package:gamr/database/projects.dart';

class ProjectListItem extends StatelessWidget {
  const ProjectListItem(
      {Key? key, required this.project, required this.projectId})
      : super(key: key);
  final Project project;
  final int projectId;
  @override
  Widget build(BuildContext context) {
    return Text(project.name);
  }
}
