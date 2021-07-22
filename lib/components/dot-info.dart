import 'package:flutter/material.dart';
import 'package:gamr/models/drawer/point.dart';

class DotInfo extends StatelessWidget {
  const DotInfo({Key? key, required this.selectedDot}) : super(key: key);
  final Dot selectedDot;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pont részletek'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Rank",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(selectedDot.rank.toString()),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "X",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(selectedDot.x.toStringAsFixed(4)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Y",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(selectedDot.y.toStringAsFixed(4)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Z",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(selectedDot.z.toStringAsFixed(4)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Név",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(selectedDot.name),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Bezárás'),
        ),
      ],
    );
  }
}
