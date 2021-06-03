import 'package:flutter/material.dart';
import 'package:gamr/pages/drawer.dart';
import 'package:gamr/pages/project-list.dart';
import 'method/project-method.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB().init();

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

        return MaterialPageRoute(builder: (context) => ProjectList());
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
