import 'package:flutter/material.dart';
import 'package:gamr/models/database/projects.dart';
import 'package:gamr/services/database-service.dart';

class RenameProject extends StatefulWidget {
  final Project project;
  const RenameProject({
    Key? key,
    required this.project,
  }) : super(key: key);
  @override
  RenameProjectState createState() => RenameProjectState();
}

class RenameProjectState extends State<RenameProject> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(text: '');

  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Projekt átnevezése"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              controller: name..text = widget.project.name,
              decoration: InputDecoration(
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
                widget.project..name = this.name.text);
            Navigator.of(context).pop();
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
