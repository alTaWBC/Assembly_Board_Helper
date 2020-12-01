import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secret_voting/Admin/admin_pages.dart';
import 'package:secret_voting/User/user_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      shortcuts: Map.of(WidgetsApp.defaultShortcuts)..remove(LogicalKeyboardKey.arrowLeft)..remove(LogicalKeyboardKey.arrowRight),
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/Admin':
            return MaterialPageRoute(builder: (_) => AdminPages(), settings: RouteSettings(name: "/"));
          case '/User':
          case '/':
          default:
            return MaterialPageRoute(builder: (_) => UserPages(), settings: RouteSettings(name: "/User"));
        }
      },
      initialRoute: '/Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
