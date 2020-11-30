import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Probe extends StatefulWidget {
  Probe({Key key}) : super(key: key);

  @override
  _ProbeState createState() => _ProbeState();
}

class _ProbeState extends State<Probe> with AutomaticKeepAliveClientMixin<Probe> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                  Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('Voto Enviado!')));
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
                  Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('Voto Enviado!')));
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
    );
  }
}
