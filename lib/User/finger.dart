import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Finger extends StatefulWidget {
  Finger({Key key}) : super(key: key);

  @override
  _FingerState createState() => _FingerState();
}

class _FingerState extends State<Finger> {
  List fingerOptions = ['i', 'ii'];
  List nameOptions = ['1', '2'];
  int _votingValue = 0;
  int _nameValue = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('finger_priority').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        fingerOptions = snapshot.data.documents[0]['priority'];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    value: _nameValue,
                    onChanged: (value) {
                      setState(() {
                        _nameValue = value;
                      });
                    },
                    items: nameOptions
                        .map((e) => DropdownMenuItem(
                              value: nameOptions.indexOf(e),
                              child: Text(e),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  DropdownButton(
                    value: _votingValue,
                    onChanged: (value) {
                      setState(() {
                        _votingValue = value;
                      });
                    },
                    items: fingerOptions
                        .map((e) => DropdownMenuItem(
                              value: fingerOptions.indexOf(e),
                              child: Text(e),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                var vote = {
                  'finger': fingerOptions[_votingValue],
                  'name': nameOptions[_nameValue],
                };
                var voteCollection = FirebaseFirestore.instance.collection('finger');
                voteCollection.doc().set(vote);
              },
              child: Text("Enviar Voto"),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('finger').snapshots(),
              builder: (context, snapshot) {
                List fingers = [];
                List documentIds = [];

                for (var document in snapshot.data.documents) {
                  if (document['name'] != '1') continue;

                  fingers.add(document['finger']);
                  documentIds.add(document.documentID);
                }

                return Flexible(
                  child: ListView.builder(
                    itemCount: fingers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          FirebaseFirestore.instance.collection('finger').doc(documentIds[index]).delete();
                        },
                        title: Text(fingers[index]),
                        trailing: IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance.collection('finger').doc(documentIds[index]).delete();
                          },
                          icon: Icon(Icons.delete_forever),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
