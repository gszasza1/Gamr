import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:gamr/constant/email_menu.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/text_dot.dart';
import 'package:gamr/services/csv_service.dart';
import 'package:gamr/services/database_service.dart';
import 'package:gamr/services/json_service.dart';
import 'package:gamr/services/txt_service.dart';

class SendEmailPage extends StatefulWidget {
  const SendEmailPage({Key? key, required this.projectId}) : super(key: key);
  final int projectId;

  @override
  _SendEmailPageState createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController subjectController = TextEditingController(text: '');
  TextEditingController messageController = TextEditingController(text: '');

  List<Dot> allDots = [];
  late final String projectName;
  EmailMenu emailOption = EmailMenu.asCsv;

  bool _validEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  Future<void> initializeProjectName() async {
    projectName = await DBService().getProjectName(widget.projectId);
  }

  Future<void> initializeDots() async {
    final dbDotList = await DBService().getProjectDots(widget.projectId);
    final transformedDots = dbDotList
        .map((e) => Dot.dzParameter(e.x, e.y, e.z, id: e.id, name: e.name))
        .toList();
    setState(() {
      allDots.addAll(transformedDots);
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDots();
    initializeProjectName();
  }

  Future<void> sendMail() async {
    String? path;
    if (emailOption == EmailMenu.asJson) {
      path = await JsonService()
          .createJsonfromDots(projectName: projectName, dots: allDots);
    }

    if (emailOption == EmailMenu.asCsv) {
      path = await CSVService()
          .createCSVfromDots(projectName: projectName, dots: allDots);
    }
    if (emailOption == EmailMenu.asTxt) {
      path = await TxtService()
          .createTxtfromDots(projectName: projectName, dots: allDots);
    }
    if (emailOption == EmailMenu.asText) {
      messageController.text = TextDot.generateStringFromDots(allDots);
    }
    final Email email = Email(
      body: messageController.text,
      subject: subjectController.text,
      recipients: [emailController.text],
      attachmentPaths: path != null ? [path] : [],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Sikeres továbbítás';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Küldés e-mailben'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (input) =>
                        _validEmail(emailController.value.text)
                            ? null
                            : "Írgyá rendes e-mailt vaze",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail cím',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tárgy',
                    ),
                  ),
                ),
                if (emailOption != EmailMenu.asText)
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Üzenet',
                      ),
                    ),
                  ),
                Expanded(
                  child: RadioListTile(
                    title: const Text(".CSV"),
                    value: EmailMenu.asCsv,
                    groupValue: emailOption,
                    onChanged: (EmailMenu? value) {
                      setState(() {
                        emailOption = value ?? EmailMenu.asCsv;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text(".JSON"),
                    value: EmailMenu.asJson,
                    groupValue: emailOption,
                    onChanged: (EmailMenu? value) {
                      setState(() {
                        emailOption = value ?? EmailMenu.asCsv;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text(".TXT"),
                    value: EmailMenu.asTxt,
                    groupValue: emailOption,
                    onChanged: (EmailMenu? value) {
                      setState(() {
                        emailOption = value ?? EmailMenu.asCsv;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Szöveg"),
                    value: EmailMenu.asText,
                    groupValue: emailOption,
                    onChanged: (EmailMenu? value) {
                      setState(() {
                        emailOption = value ?? EmailMenu.asCsv;
                        messageController.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Mégse"),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    sendMail();
                  },
                  child: const Text("Küldés"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
