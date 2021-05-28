import 'package:flutter/material.dart';
import 'package:gamr/point.dart';

class DotListItem extends StatelessWidget {
  const DotListItem(
      {required Key key,
      required this.callback,
      required this.index,
      required this.value})
      : super(key: key);
  final Dot value;
  final int index;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Text(
            (index + 1).toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          margin: const EdgeInsets.only(
            right: 10,
          ),
        ),
        Container(
          child: Text(value.x.toStringAsFixed(2)),
          margin: const EdgeInsets.only(
            right: 10,
          ),
        ),
        Container(
          child: Text(value.y.toStringAsFixed(2)),
          margin: const EdgeInsets.only(
            right: 10,
          ),
        ),
        Text(value.z.toStringAsFixed(2)),
        Expanded(
          flex: 1,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                tooltip: 'Delete',
                onPressed: () {
                  callback();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
