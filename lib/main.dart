import 'package:flutter/material.dart';
import 'package:secret_voting/Admin/admin_pages.dart';
import 'package:secret_voting/User/user_pages.dart';
import 'package:secret_voting/probe.dart';
import 'package:secret_voting/settings.dart';
import 'package:secret_voting/vote.dart';

import 'Admin/probing.dart';

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
            return MaterialPageRoute(builder: (_) => Settings(), settings: RouteSettings(name: "/Settings"));
          case '/Vote':
            return MaterialPageRoute(builder: (_) => Vote(), settings: RouteSettings(name: "/Vote"));
          case '/Probe':
            return MaterialPageRoute(builder: (_) => Probe(), settings: RouteSettings(name: "/Probe"));
          case '/Probing':
            return MaterialPageRoute(builder: (_) => Probing(), settings: RouteSettings(name: "/Probing"));
          case '/':
          default:
            return MaterialPageRoute(builder: (_) => AdminPages(), settings: RouteSettings(name: "/"));
        }
      },
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
