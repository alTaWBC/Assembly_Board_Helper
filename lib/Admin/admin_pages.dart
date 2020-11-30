import 'package:flutter/material.dart';
import 'package:secret_voting/Admin/fingers.dart';
import 'package:secret_voting/Admin/probing.dart';
import 'package:secret_voting/User/probe.dart';
import 'package:secret_voting/Admin/settings.dart';
import 'package:secret_voting/User/vote.dart';

class AdminPages extends StatefulWidget {
  AdminPages({Key key}) : super(key: key);

  @override
  _AdminPagesState createState() => _AdminPagesState();
}

class _AdminPagesState extends State<AdminPages> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: TabBar(
              tabs: [
                Tab(
                  child: Text('Dedos'),
                  icon: Icon(Icons.fingerprint),
                ),
                Tab(
                  child: Text('Probing'),
                  icon: Icon(Icons.thumbs_up_down),
                ),
                Tab(
                  child: Text('Votação'),
                  icon: Icon(Icons.how_to_vote),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Fingers(),
            Probing(),
            Settings(),
          ],
        ),
      ),
    );
  }
}
