import 'package:flutter/material.dart';

Widget buildDetailsPopup(BuildContext context, Details details) {
  return DetailsPopup(
    details: details,
  );
}

class Details {
  final double averageY;
  final int totalDots;
  final double averageAngle;

  Details(this.averageY, this.totalDots, this.averageAngle);
}

class DetailsPopup extends StatelessWidget {
  const DetailsPopup({Key? key, required this.details}) : super(key: key);
  final Details details;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text("Total dots: ")),
            Text(details.totalDots.toString())
          ]),
          Row(children: [
            Expanded(child: Text("Average Y: ")),
            Text(details.averageY.toStringAsFixed(5))
          ]),
          Row(children: [
            Expanded(child: Text("Average angle: ")),
            Text(details.averageAngle.toStringAsFixed(3) + " °")
          ]),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
