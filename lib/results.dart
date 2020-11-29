import 'package:flutter/material.dart';
import 'package:secret_voting/voting.dart';

class Results extends StatefulWidget {
  Results({Key key}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  int fulls = 2;
  List<String> missing = ["Gata", "Gatinha"];
  Voting vote;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListTile(
          title: Text("Settings"),
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.of(context).pushNamed("/Settings");
          },
        ),
      ),
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(fulls == 1
                    ? "Votou $fulls Full em ${missing.length}"
                    : "Votaram $fulls Fulls em ${missing.length}"),
                SizedBox(height: 20),
                Text(
                  "Ainda falta votar:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ...(missing.map((e) => Text(e)).toList()),
              ],
            ),
            Column(
              children: [
                Text(
                  "Resultado da Votação",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "O resultado da votação só irá aparecer quando todos os Fulls votarem"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
