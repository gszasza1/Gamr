import 'package:flutter/material.dart';

class AreaDetailsPopup extends StatelessWidget {
  const AreaDetailsPopup(
      {Key? key, required this.totalDots, required this.totalArea})
      : super(key: key);
  final double totalArea;
  final int totalDots;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Terület'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Összes pont",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(totalDots.toString())),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Lefedett terület",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Text("${totalArea.toStringAsFixed(4)} m\u00B2"),
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
