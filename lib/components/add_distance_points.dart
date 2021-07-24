import 'package:flutter/material.dart';

class AddDistancePoints extends StatefulWidget {
  const AddDistancePoints({Key? key}) : super(key: key);
  @override
  AddDistancePointsState createState() => AddDistancePointsState();
}

class AddDistancePointsState extends State<AddDistancePoints> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Felvett osztott pontok hozzáadása'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Mégse'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
