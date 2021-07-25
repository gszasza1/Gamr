import 'package:flutter/material.dart';
import 'package:gamr/services/database_service.dart';

class AddNewProjectPopup extends StatefulWidget {
  const AddNewProjectPopup({Key? key, required this.refreshList})
      : super(key: key);

  final Function refreshList;
  @override
  AddNewProjectPopupState createState() => AddNewProjectPopupState();
}

class AddNewProjectPopupState extends State<AddNewProjectPopup> {
  TextEditingController nameController = TextEditingController(text: '');

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Új projekt'),
      content: TextFormField(
        keyboardType: TextInputType.text,
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Név',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Mégse'),
        ),
        TextButton(
          onPressed: () async {
            DBService().addProject(nameController.text);
            widget.refreshList();
            Navigator.of(context).pop();
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
