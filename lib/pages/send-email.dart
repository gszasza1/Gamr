import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:gamr/constant/email-menu.dart';
import 'package:gamr/models/drawer/point.dart';
import 'package:gamr/models/service/text-dot.dart';
import 'package:gamr/services/csv-service.dart';
import 'package:gamr/services/database-service.dart';
import 'package:gamr/services/json-service.dart';
import 'package:gamr/services/txt-service.dart';

class SendEmailPage extends StatefulWidget {
  final int projectId;
  SendEmailPage({Key? key, required this.projectId}) : super(key: key);

  @override
  _SendEmailPageState createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController subjectController = TextEditingController(text: '');
  TextEditingController messageController = TextEditingController(text: '');

  List<Dot> allDots = [];
  late final String projectName;
  EmailMenu emailOption = EmailMenu.as_csv;

  bool _validEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  Future<void> initializeProjectName() async {
    this.projectName = await DBService().getProjectName(widget.projectId);
  }

  Future<void> initializeDots() async {
    final dbDotList = await DBService().getProjectDots(widget.projectId);
    final transformedDots =
        dbDotList.map((e) => Dot.dzParameter(e.x, e.y, e.z, id: e.id)).toList();
    setState(() {
      allDots.addAll(transformedDots);
    });
  }

  @override
  void initState() {
    super.initState();
    this.initializeDots();
    this.initializeProjectName();
  }

  Future<void> sendMail() async {
    String? path;
    if (emailOption == EmailMenu.as_json) {
      path = await JsonService()
          .createJsonfromDots(projectName: projectName, dots: this.allDots);
    }

    if (emailOption == EmailMenu.as_csv) {
      path = await CSVService()
          .createCSVfromDots(projectName: projectName, dots: this.allDots);
    }
    if (emailOption == EmailMenu.as_txt) {
      path = await TxtService()
          .createTxtfromDots(projectName: projectName, dots: this.allDots);
    }
    if (emailOption == EmailMenu.as_text) {
      messageController.text = TextDot.generateStringFromDots(allDots);
    }
    print(path);
    final Email email = Email(
      body: messageController.text,
      subject: subjectController.text,
      recipients: [emailController.text],
      attachmentPaths: path != null ? [path] : [],
      isHTML: false,
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
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (input) =>
                        this._validEmail(emailController.value.text)
                            ? null
                            : "Írgyá rendes e-mailt vaze",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail cím',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tárgy',
                    ),
                  ),
                ),
                if (this.emailOption != EmailMenu.as_text)
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Üzenet',
                      ),
                    ),
                  ),
                Expanded(
                  child: RadioListTile(
                    title: const Text(".CSV"),
                    value: EmailMenu.as_csv,
                    groupValue: emailOption,
                    onChanged: (EmailMenu? value) {
                      setState(() {
                        this.emailOption = value ?? EmailMenu.as_csv;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text(".JSON"),
                    value: EmailMenu.as_json,
                    groupValue: emailOption,
                    onChanged: (EmailMenu? value) {
                      setState(() {
                        this.emailOption = value ?? EmailMenu.as_csv;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text(".TXT"),
                    value: EmailMenu.as_txt,
                    groupValue: emailOption,
                    onChanged: (EmailMenu? value) {
                      setState(() {
                        this.emailOption = value ?? EmailMenu.as_csv;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Szöveg"),
                    value: EmailMenu.as_text,
                    groupValue: emailOption,
                    onChanged: (EmailMenu? value) {
                      setState(() {
                        this.emailOption = value ?? EmailMenu.as_csv;
                        this.messageController.clear();
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
                  child: Text("Mégse"),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                          this.sendMail();
                        },
                  child: Text("Küldés"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
