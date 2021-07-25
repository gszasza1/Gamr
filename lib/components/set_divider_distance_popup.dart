import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DividerDistancePopup extends StatefulWidget {
  const DividerDistancePopup({
    Key? key,
    required this.isEqualDistances,
    required this.distance,
    required this.save,
  }) : super(key: key);
  final double distance;
  final bool isEqualDistances;
  final void Function(String distance, bool isEqualDistances) save;
  @override
  DividerDistancePopupState createState() => DividerDistancePopupState();
}

class DividerDistancePopupState extends State<DividerDistancePopup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController distance;
  late bool isEqualDistances;

  @override
  void initState() {
    super.initState();
    distance = TextEditingController(text: '');
    isEqualDistances = widget.isEqualDistances;
    distance.text = widget.distance > 0
        ? isEqualDistances
            ? widget.distance.toStringAsFixed(0)
            : widget.distance.toStringAsFixed(4)
        : '';
  }

  @override
  void dispose() {
    distance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Határolás"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: isEqualDistances,
                title: const Text("Egyenlő részekre"),
                onChanged: (e) {
                  setState(() {
                    isEqualDistances = !isEqualDistances;
                    distance.text = "";
                  });
                }),
            TextFormField(
              inputFormatters: isEqualDistances
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: distance,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: isEqualDistances ? 'Rész' : 'Távolság (m)',
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
            widget.save(distance.value.text, isEqualDistances);
            Navigator.of(context).pop();
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
