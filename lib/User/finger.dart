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
            voteCollection.doc(nameOptions[_nameValue]).get().then((snapshot) {
              if (snapshot.exists) {
                Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('Já votaste!')));
              } else {
                snapshot.reference.set(vote).then((value) => Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text('Voto foi enviado com sucesso!'),
                    )));
              }
            });
          },
          child: Text("Enviar Voto"),
        ),
      ],
    );
  }
}
