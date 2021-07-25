import 'package:flutter/material.dart';
import 'package:gamr/models/database/projects.dart';
import 'package:gamr/services/database_service.dart';

class RenameProject extends StatefulWidget {
  const RenameProject({
    Key? key,
    required this.project,
  }) : super(key: key);
  final Project project;
  @override
  RenameProjectState createState() => RenameProjectState();
}

class RenameProjectState extends State<RenameProject> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(text: '');

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Projekt átnevezése"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              controller: name..text = widget.project.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Z',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Bezár'),
        ),
        TextButton(
          onPressed: () {
            DBService().updateProject(
                widget.project..name = name.text);
            Navigator.of(context).pop();
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
