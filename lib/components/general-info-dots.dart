import 'package:flutter/material.dart';

class GeneralInformationDots extends StatefulWidget {
  const GeneralInformationDots(
      {Key? key,
      required this.degreeBeteenDots,
      required this.zHeightVariationBetweenDots,
      required this.distance3D,
      required this.distance2D})
      : super(key: key);
  final double distance3D;
  final double distance2D;
  final double degreeBeteenDots;
  final double zHeightVariationBetweenDots;
  @override
  GeneralInformationDotsState createState() => GeneralInformationDotsState();
}

class GeneralInformationDotsState extends State<GeneralInformationDots> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('2 pont közti adat'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Vetített távolság (2D)",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(widget.distance2D.toStringAsFixed(4) + " m")),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text("Magasság különbség",
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                  widget.zHeightVariationBetweenDots.toStringAsFixed(4) +
                      " m")),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text("Távolság (3D)",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(widget.distance3D.toStringAsFixed(4) + " m")),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text("Teljes meredekség",
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          Text(widget.degreeBeteenDots.toStringAsFixed(4) + " °"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Bezár'),
        ),
      ],
    );
  }
}
