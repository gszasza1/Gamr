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
  final double totalDistance;

  Details(this.averageY, this.totalDots, this.averageAngle, this.totalDistance);
}

class DetailsPopup extends StatelessWidget {
  const DetailsPopup({Key? key, required this.details}) : super(key: key);
  final Details details;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Részletek'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text("Összes pont: ")),
            Text(details.totalDots.toString())
          ]),
          Row(children: [
            Expanded(child: Text("Átlagos magasság: ")),
            Text(details.averageY.toStringAsFixed(5))
          ]),
          Row(children: [
            Expanded(child: Text("Teljes meredekség: ")),
            Text(details.averageAngle.toStringAsFixed(3) + " °")
          ]),
          Row(children: [
            Expanded(child: Text("Teljes 2D hossz: ")),
            Text(details.totalDistance.toStringAsFixed(3) + " m")
          ]),
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
