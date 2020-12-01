import 'package:cloud_firestore/cloud_firestore.dart';
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
        String name = settings.name;
        String parameter = '';

        if (name.contains('/User')) {
          parameter = name.substring(6);
          name = '/User';
        }

        switch (name) {
          case '/Admin':
            return MaterialPageRoute(builder: (_) => AdminPages(), settings: RouteSettings(name: "/"));
          case '/User':
            return MaterialPageRoute(builder: (_) => UserPages(parameter), settings: RouteSettings(name: "/"));
          case '/':
          default:
            return MaterialPageRoute(builder: (_) => Login(), settings: RouteSettings(name: "/"));
        }
      },
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _name = 0;
  List names;
  double opacity = 0.0;
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text('Login Page'),
          onTap: () => setState(
            () => opacity = 1 - opacity,
          ),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('vote_options').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              names = snapshot.data.documents[0]['names'];
              return DropdownButton(
                value: _name,
                items: names
                    .map((e) => DropdownMenuItem(
                          value: names.indexOf(e),
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _name = value);
                },
              );
            },
          ),
          RaisedButton(
            child: Text('Login'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/User/${names[_name]}');
            },
          ),
          Opacity(
            opacity: opacity,
            child: TextFormField(
              controller: password,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Opacity(
            opacity: opacity,
            child: RaisedButton(
              child: Text('Introduzir password de administador'),
              onPressed: () {
                if (password.text == 'MagAdmin') Navigator.of(context).pushReplacementNamed('/Admin');
              },
            ),
          )
        ],
      ),
    );
  }
}
