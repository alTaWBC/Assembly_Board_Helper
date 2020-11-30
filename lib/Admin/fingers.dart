import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Fingers extends StatefulWidget {
  Fingers({Key key}) : super(key: key);

  @override
  _FingersState createState() => _FingersState();
}

class _FingersState extends State<Fingers> {
  List<String> fingers;
  List<String> names;
  Map<String, List<String>> fullList;
  Map<String, List<String>> idList;
  List<String> priorityList;
  List<String> documentIds;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('finger_priority').snapshots(),
      builder: (context, prioritySnapshot) {
        if (!prioritySnapshot.hasData) return CircularProgressIndicator();

        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('finger').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            fingers = [];
            names = [];
            priorityList = [];
            documentIds = [];
            fullList = {};
            idList = {};

            for (String priority in prioritySnapshot.data.documents[0]['priority']) {
              fullList.putIfAbsent(priority, () => new List<String>());
              idList.putIfAbsent(priority, () => new List<String>());
              priorityList.add(priority);
            }

            for (var document in snapshot.data.documents) {
              fullList[document['finger']].add(document['name']);
              idList[document['finger']].add(document.documentID);
            }

            for (var priority in priorityList) {
              names.addAll(fullList[priority]);
              fingers.addAll(fullList[priority].map((e) => priority).toList());
              documentIds.addAll(idList[priority]);
            }
            print(names);
            print(fingers);

            return ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return ListTile(
                  hoverColor: Colors.grey[60],
                  title: Text(names[index]),
                  subtitle: Text(fingers[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      FirebaseFirestore.instance.collection('finger').doc(documentIds[index]).delete();
                    },
                  ),
                  onTap: () {
                    FirebaseFirestore.instance.collection('finger').doc(documentIds[index]).delete();
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
