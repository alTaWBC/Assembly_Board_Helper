import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Probe extends StatefulWidget {
  Probe({Key key}) : super(key: key);

  @override
  _ProbeState createState() => _ProbeState();
}

class _ProbeState extends State<Probe> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Probe"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('probing').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return RefreshProgressIndicator();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      FirebaseFirestore.instance.collection('probe').doc().set({'vote': 'b'});
                    },
                    title: Text(
                      snapshot.data.documents[0]['b'],
                    ),
                    leading: Icon(
                      Icons.thumb_up,
                      color: Colors.green,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      FirebaseFirestore.instance.collection('probe').doc().set({'vote': 'p'});
                    },
                    title: Text(snapshot.data.documents[0]['p']),
                    leading: Icon(
                      Icons.thumb_down,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}


