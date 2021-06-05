import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SendEmailPage extends StatefulWidget {
  SendEmailPage({Key? key}) : super(key: key);

  @override
  _SendEmailPageState createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  bool _validEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          validator: EmailValidator(errorText: "Írgyá rendes e-mailt vaze"),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'E-mail cím',
          ),
        ),
        TextFormField(
          controller: subjectController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Tárgy',
          ),
        ),
        TextFormField(
          controller: messageController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Üzenet',
          ),
        ),
        TextButton(
          onPressed: emailController.value.text.isEmpty ||
                  !this._validEmail(emailController.value.text)
              ? null
              : () {},
          child: Text("Küldés"),
        ),
      ],
    );
  }
}
