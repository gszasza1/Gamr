import 'package:flutter/material.dart';

class DividerDistancePopup extends StatefulWidget {
  final double distance;
  final Function save;
  const DividerDistancePopup({
    Key? key,
    required this.distance,
    required this.save,
  }) : super(key: key);
  @override
  DividerDistancePopupState createState() => DividerDistancePopupState();
}

class DividerDistancePopupState extends State<DividerDistancePopup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController distance = TextEditingController(text: '');

  void dispose() {
    distance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Határoló távolság"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              controller: distance
                ..text = widget.distance > 0
                    ? widget.distance.toStringAsFixed(5)
                    : '',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Távolság',
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
            widget.save(distance.value.text);
            Navigator.of(context).pop();
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
