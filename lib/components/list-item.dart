import 'package:flutter/material.dart';
import 'package:gamr/models/drawer/point.dart';

class DotListItem extends StatelessWidget {
  const DotListItem(
      {required Key key,
      required this.callback,
      required this.value})
      : super(key: key);
  final Dot value;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 0,
          child: Container(
            child: Text(
              (value.rank).toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            margin: const EdgeInsets.only(
              right: 10,
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Container(
            child: Text(value.x.toStringAsFixed(4)),
            margin: const EdgeInsets.only(
              right: 10,
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Container(
            child: Text(value.y.toStringAsFixed(4)),
            margin: const EdgeInsets.only(
              right: 10,
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Container(
            child: Text(value.z.toStringAsFixed(4)),
            margin: const EdgeInsets.only(
              right: 10,
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Text(value.name),
        ),
        Flexible(
          flex: 0,
          child: IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Törlés',
            onPressed: () {
              callback();
            },
          ),
        ),
      ],
    );
  }
}
