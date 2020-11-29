import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Vote extends StatefulWidget {
  const Vote({Key key}) : super(key: key);

  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  final _formKey = GlobalKey<FormState>();

  List<String> names = ["Gata", "Gatinha", "Gato"];
  List<String> votingOptions = ["Branco", "A favor"];
  int _value = 0;
  int _votingValue = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Vote"),
        ),
        body: Form(
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
                  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text('Voto foi enviado com sucesso!'),
                  ));
                },
                child: Text("Enviar Voto"),
              ),
              Flexible(
                child: StreamBuilder(
                  stream: Firestore.instance.collection('vote').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text("No data Found");

                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(snapshot.data.documents[index]['name']),
                        subtitle: Text(snapshot.data.documents[index]['full']),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
