import 'package:flutter/material.dart';
import 'package:gamr/services/database-service.dart';

Widget buildPopupDialog(BuildContext context, Function refreshList) {
  return AddNewProjectPopup(
    refreshList: refreshList,
  );
}

class AddNewProjectPopup extends StatefulWidget {
  final Function refreshList;

  const AddNewProjectPopup({Key? key, required this.refreshList})
      : super(key: key);
  @override
  AddNewProjectPopupState createState() => AddNewProjectPopupState();
}

class AddNewProjectPopupState extends State<AddNewProjectPopup> {
  TextEditingController nameController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Új projekt'),
      content: TextFormField(
        keyboardType: TextInputType.text,
        controller: nameController,
        decoration: InputDecoration(
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
