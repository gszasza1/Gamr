import 'package:flutter/material.dart';
import 'package:gamr/models/drawer/point.dart';

Widget buildPopupDialog(BuildContext context, Function save, Dot dot) {
  return EditPopup(
    dot: dot,
    save: save,
  );
}

class EditPopup extends StatefulWidget {
  final Function save;
  final Dot dot;

  const EditPopup({Key? key, required this.save, required this.dot})
      : super(key: key);
  @override
  EditPopupState createState() => EditPopupState();
}

class EditPopupState extends State<EditPopup> {
  TextEditingController xCoordRText = TextEditingController(text: '');
  TextEditingController yCoordRText = TextEditingController(text: '');
  TextEditingController zCoordRText = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Változtatás'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: xCoordRText..text = widget.dot.x.toString(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'X',
                ),
              )),
          Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: yCoordRText..text = widget.dot.y.toString(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Y',
                ),
              )),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: zCoordRText..text = widget.dot.z.toString(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Z',
            ),
          ),
        ],
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
            widget.save(
              Dot.dzParameter(
                double.tryParse(xCoordRText.text) ?? widget.dot.x,
                double.tryParse(yCoordRText.text) ?? widget.dot.y,
                double.tryParse(zCoordRText.text) ?? widget.dot.z,
                id:widget.dot.id,
              ),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
