import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Results extends StatefulWidget {
  Results({Key key}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> with AutomaticKeepAliveClientMixin<Results> {
  @override
  bool get wantKeepAlive => true;

  List missing = [];
  List voters = [];
  List fullList = [];
  List votes = [];
  List options = [];
  List<Option> results = [];

  void retrieveFirestoreSnapshotData(AsyncSnapshot<dynamic> votingOptionsSnapshot, AsyncSnapshot<dynamic> votesSnapshot) {
    missing.clear();
    voters.clear();
    fullList.clear();
    votes.clear();
    options.clear();
    results.clear();
    fullList = votingOptionsSnapshot.data.documents[0]['names'];
    options = votingOptionsSnapshot.data.documents[0]['options'];
    options.forEach((element) => results.add(new Option(element, 0)));
    for (var document in votesSnapshot.data.documents) {
      votes.add((document['vote']) as String);
      voters.add((document['name']) as String);
      results[options.indexOf(document['vote'])].count += 1;
    }

    for (String name in fullList) {
      if (voters.contains(name)) continue;
      missing.add(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('vote_options').snapshots(),
      builder: (context, votingOptionsSnapshot) {
        if (!votingOptionsSnapshot.hasData) return CircularProgressIndicator();

        return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('vote').snapshots(),
            builder: (context, votesSnapshot) {
              if (!votesSnapshot.hasData) return CircularProgressIndicator();
              retrieveFirestoreSnapshotData(votingOptionsSnapshot, votesSnapshot);
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(voters.length == 1
                            ? "Votou ${voters.length} Full em ${fullList.length}"
                            : "Votaram ${voters.length} Fulls em ${fullList.length}"),
                        SizedBox(height: 20),
                        missing.length > 0
                            ? Column(
                                children: [
                                  Text(
                                    "Ainda falta votar:",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  ...(missing.map((e) => Text(e)).toList()),
                                ],
                              )
                            : Container(),
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
                        missing.length != 0
                            ? Text("O resultado da votação só irá aparecer quando todos os Fulls votarem")
                            : Container(
                                width: size.width * .35,
                                height: size.height * .3,
                                child: charts.BarChart([
                                  new charts.Series<Option, String>(
                                    id: 'Votes',
                                    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                                    domainFn: (option, _) => option.name,
                                    measureFn: (option, _) => option.count,
                                    data: results,
                                  )
                                ]),
                              ),
                      ],
                    )
                  ],
                ),
              );
            });
      },
      // ),
    );
  }
}

class Option {
  String name;
  int count;

  Option(this.name, this.count);
}
