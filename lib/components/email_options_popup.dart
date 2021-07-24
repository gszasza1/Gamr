import 'package:flutter/material.dart';
import 'package:gamr/constant/email_menu.dart';

class EmailOptionPopup extends StatelessWidget {
  const EmailOptionPopup({Key? key}) : super(key: key);

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
          ListTile(
            title: const Text('Szövegként'),
            onTap: () {
              Navigator.pop(context, EmailMenu.asText);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          // ignore: prefer_const_constructors
          child: Text('Bezárás'),
        ),
      ],
    );
  }
}
