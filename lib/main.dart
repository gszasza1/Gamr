import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamr/pages/project-list.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart';
Future<void> main() async {
  Store _store;
  WidgetsFlutterBinding.ensureInitialized();
  Directory? appDocDir = await getApplicationDocumentsDirectory();
  _store = Store(getObjectBoxModel(), directory: appDocDir.path);
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
