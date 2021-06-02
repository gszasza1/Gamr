import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamr/database/points.dart';
import 'package:gamr/database/projects.dart';
import 'package:gamr/pages/project-list.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory? appDocDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocDir.path);
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(DBPointAdapter());

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

        // Handle '/details/:id'
        final uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'project') {
          final id = int.parse(uri.pathSegments[1]);
          return MaterialPageRoute(
              settings: RouteSettings(name: "/movie/$id"),
              builder: (context) => Drawer());
        }

        return MaterialPageRoute(builder: (context) => ProjectList());
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
