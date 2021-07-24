import 'package:flutter/material.dart';
import 'package:gamr/constant/email_menu.dart';

class SaveFilePopup extends StatelessWidget {
  const SaveFilePopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: const Text('Fájlként (*.CSV)'),
            onTap: () {
              Navigator.pop(context, EmailMenu.asCsv);
            },
          ),
          ListTile(
            title: const Text('Fájlként (*.JSON)'),
            onTap: () {
              Navigator.pop(context, EmailMenu.asJson);
            },
          ),
          ListTile(
            title: const Text('Fájlként (*.TXT)'),
            onTap: () {
              Navigator.pop(context, EmailMenu.asTxt);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Bezárás'),
        ),
      ],
    );
  }
}
