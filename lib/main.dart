import 'package:flutter/material.dart';
import 'package:gamr/pages/drawer.dart';
import 'package:gamr/pages/project_list.dart';
import 'package:gamr/services/csv_service.dart';
import 'package:gamr/services/database_service.dart';
import 'package:gamr/services/json_service.dart';
import 'package:gamr/services/txt_service.dart';

import 'pages/send_email.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService().init();
  await CSVService().init();
  await JsonService().init();
  await TxtService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProjectList(),
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(
              settings: const RouteSettings(name: "/"),
              builder: (context) => ProjectList());
        }

        // Handle '/project/:id'
        final uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'project') {
          final id = int.parse(uri.pathSegments[1]);
          return MaterialPageRoute(
              settings: RouteSettings(name: "/project/$id"),
              builder: (context) => DrawerPage(projectId: id));
        }
        if (uri.pathSegments.length == 3 &&
            uri.pathSegments.first == 'project' && uri.pathSegments[2] == 'email') {
          final id = int.parse(uri.pathSegments[1]);
          return MaterialPageRoute(
              settings: RouteSettings(name: "/project/$id/email"),
              builder: (context) => SendEmailPage(projectId: id));
        }

        return MaterialPageRoute(builder: (context) => ProjectList());
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
