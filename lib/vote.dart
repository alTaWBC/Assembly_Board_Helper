import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Vote extends StatefulWidget {
  const Vote({Key key}) : super(key: key);

  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> with AutomaticKeepAliveClientMixin<Vote> {
  @override
  bool get wantKeepAlive => true;
  final _formKey = GlobalKey<FormState>();

  List names = [];
  List votingOptions = [];
  int _value = 0;
  int _votingValue = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('vote_options').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("No data Found");

        names = snapshot.data.documents[0]['names'];
        votingOptions = snapshot.data.documents[0]['options'];

        return Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                      items: names
                          .map((e) => DropdownMenuItem(
                                value: names.indexOf(e),
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
                      items: votingOptions
                          .map((e) => DropdownMenuItem(
                                value: votingOptions.indexOf(e),
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
                    'vote': votingOptions[_votingValue],
                    'name': names[_value],
                  };
                  var voteCollection = FirebaseFirestore.instance.collection('vote');
                  voteCollection.doc(names[_value]).get().then((snapshot) {
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
          ),
        );
      },
    );
  }
}
