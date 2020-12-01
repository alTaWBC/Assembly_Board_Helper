import 'package:flutter/material.dart';
import 'package:secret_voting/User/finger.dart';
import 'package:secret_voting/User/probe.dart';
import 'package:secret_voting/User/vote.dart';

class UserPages extends StatefulWidget {
  final String parameter;

  UserPages(this.parameter);

  @override
  _UserPagesState createState() => _UserPagesState();
}

class _UserPagesState extends State<UserPages> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            Finger(widget.parameter),
            Probe(),
            Vote(widget.parameter),
          ],
        ),
      ),
    );
  }
}
