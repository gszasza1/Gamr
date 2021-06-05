import 'package:flutter/material.dart';
import 'package:gamr/constant/email-menu.dart';

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
            title: Text('Fájlként (*.CSV)'),
            onTap: () {
              Navigator.pop(context, EmailMenu.as_csv);
            },
          ),
          ListTile(
            title: Text('Fájlként (*.JSON)'),
            onTap: () {
              Navigator.pop(context, EmailMenu.as_json);
            },
          ),
          ListTile(
            title: Text('Szövegként'),
            onTap: () {
              Navigator.pop(context, EmailMenu.as_text);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: Text('Bezárás'),
        ),
      ],
    );
  }
}
