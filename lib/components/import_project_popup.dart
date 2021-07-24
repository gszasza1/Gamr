import 'package:flutter/material.dart';
import 'package:gamr/models/database/points.dart';

class ImportPopup extends StatefulWidget {
  const ImportPopup(
      {Key? key, required this.projectName, required this.dotList})
      : super(key: key);
  final String projectName;
  final List<DBPoint> dotList;

  @override
  _ImportPopupState createState() => _ImportPopupState();
}

class _ImportPopupState extends State<ImportPopup> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.projectName;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Importálás'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Projekt név',
                ),
              ),
            ),
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: widget.dotList
                  .map((e) => Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: Text(e.rank.toString()),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: Text(e.x.toStringAsFixed(3)),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: Text(e.y.toStringAsFixed(3)),
                            ),
                          ),
                          Expanded(child: Text(e.z.toStringAsFixed(3))),
                        ],
                      ))
                  .toList(),
            ))
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Mégse'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, controller.text);
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
