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
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/project/$projectId',
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xfffff3f3f3)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(project.name,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(
                project.creation.toString(),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
