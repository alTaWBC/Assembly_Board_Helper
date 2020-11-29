import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
        body: Form(
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
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Nome das Full Members",
                          hintText: "Separar por enter"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {},
                      decoration:
                          InputDecoration(labelText: "Opções de Votação"),
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
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text(
                            'Mudanças foram Guardadas. Votos foram limpos'),
                      ));
                    },
                    child: Text("Efetuar mudanças"),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  RaisedButton(
                    onPressed: () {
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
        ));
  }
}
