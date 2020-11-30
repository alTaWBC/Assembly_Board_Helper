import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController namesController = TextEditingController();
  TextEditingController optionsController = TextEditingController();
  String id = "";

  void clearVotes() {
    FirebaseFirestore.instance.collection('vote').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListTile(
            title: Text("Results"),
            leading: Icon(Icons.how_to_vote),
            onTap: () {
              Navigator.of(context).pushNamed("/Results");
            },
          ),
        ),
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('vote_options').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text("No data Found");

              List list = snapshot.data.documents[0]['names'];
              String namesString = "";
              list.forEach((element) => namesString += "$element\n");
              namesController.text = namesString.trim();

              list = snapshot.data.documents[0]['options'];
              String optionsString = "";
              list.forEach((element) => optionsString += "$element\n");
              optionsController.text = optionsString.trim();

              return Form(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: TextFormField(
                            onChanged: (value) {},
                            keyboardType: TextInputType.multiline,
                            controller: namesController,
                            maxLines: null,
                            decoration: InputDecoration(labelText: "Nome das Full Members", hintText: "Separar por enter"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            controller: optionsController,
                            maxLines: null,
                            onChanged: (value) {},
                            decoration: InputDecoration(labelText: "Opções de Votação"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            var settingsMap = {
                              'names': namesController.text.split('\n'),
                              'options': optionsController.text.split('\n'),
                            };
                            while (settingsMap['options'].contains('')) settingsMap['options'].remove("");
                            while (settingsMap['names'].contains('')) settingsMap['names'].remove("");
                            FirebaseFirestore.instance.collection('vote_options').doc(snapshot.data.documents[0].documentID).set(settingsMap);
                            clearVotes();
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: new Text('Mudanças foram Guardadas. Votos foram limpos'),
                            ));
                          },
                          child: Text("Efetuar mudanças"),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        RaisedButton(
                          onPressed: () {
                            clearVotes();
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: new Text('Votos foram limpos.'),
                            ));
                          },
                          child: Text("Limpar Votos"),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }));
  }
}
