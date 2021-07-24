import 'package:flutter/material.dart';

class GeneralInformationDots extends StatelessWidget {
  const GeneralInformationDots(
      {Key? key,
      required this.degreeBeteenDots,
      required this.zHeightVariationBetweenDots,
      required this.zHeightDegree,
      required this.distance3D,
      required this.distance2D})
      : super(key: key);
  final double distance3D;
  final double distance2D;
  final double degreeBeteenDots;
  final double zHeightVariationBetweenDots;
  final double zHeightDegree;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('2 pont közti adat'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Vetített távolság (2D)",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text("${distance2D.toStringAsFixed(4)} m")),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text("Magasság különbség",
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child:
                  Text("${(zHeightVariationBetweenDots*100).toStringAsFixed(2)} cm")),
          // ignore: prefer_const_constructors
         const  Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text("Távolság (3D)",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text("${distance3D.toStringAsFixed(4)} m")),
          // ignore: prefer_const_constructors
         const  Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text("1 m-en meredekség",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text("${zHeightDegree.toStringAsFixed(4)} %")),
         const  Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text("Teljes meredekség",
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          Text("${degreeBeteenDots.toStringAsFixed(4)} °"),
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
