import 'package:flutter/material.dart';
import 'package:secret_voting/results.dart';
import 'package:secret_voting/settings.dart';
import 'package:secret_voting/vote.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/Settings':
            return MaterialPageRoute(
                builder: (_) => Settings(),
                settings: RouteSettings(name: "/Settings"));
          case '/Vote':
            return MaterialPageRoute(
                builder: (_) => Vote(), settings: RouteSettings(name: "/Vote"));
          case '/Results':
            return MaterialPageRoute(
                builder: (_) => Results(),
                settings: RouteSettings(name: "/Results"));
          case '/':
          default:
            return MaterialPageRoute(
                builder: (_) => Vote(), settings: RouteSettings(name: "/Vote"));
        }
      },
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
