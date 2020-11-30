import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class Probing extends StatefulWidget {
  Probing({Key key}) : super(key: key);

  @override
  _ProbingState createState() => _ProbingState();
}

class _ProbingState extends State<Probing> {
  TextEditingController probingBController = new TextEditingController();
  TextEditingController probingPController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ProbeResult> results = [];

  void clearProbe() {
    FirebaseFirestore.instance.collection('probe').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Probing Definitions'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('probing').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading');

          probingBController.text = snapshot.data.documents[0]['b'];
          probingPController.text = snapshot.data.documents[0]['p'];

          return Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: size.width * .4,
                      child: TextFormField(
                        controller: probingBController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(labelText: "Opção A", icon: Icon(Icons.thumb_up)),
                      ),
                    ),
                    Container(
                      width: size.width * .4,
                      child: TextFormField(
                        controller: probingPController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(labelText: "Opção B", icon: Icon(Icons.thumb_down)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        FirebaseFirestore.instance.collection('probing').doc(snapshot.data.documents[0].documentID).set({
                          'b': probingBController.text,
                          'p': probingPController.text,
                        });
                        clearProbe();
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text('Mudanças foram Guardadas. Votos foram limpos'),
                        ));
                      },
                      child: Text('Change Probe'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        clearProbe();
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text('Votos foram limpos'),
                        ));
                      },
                      child: Text('Reset Votes'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Resultado do Probing",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('/probe').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Loading Results');

                    results = [
                      new ProbeResult('b', 0, charts.MaterialPalette.green.shadeDefault),
                      new ProbeResult('p', 0, charts.MaterialPalette.red.shadeDefault)
                    ];
                    for (var vote in snapshot.data.documents) {
                      vote['vote'] == 'b' ? results[0].count += 1 : results[1].count += 1;
                    }

                    return Column(
                      children: [
                        Container(
                          width: size.width * .35,
                          height: size.height * .3,
                          child: charts.BarChart(
                            [
                              new charts.Series<ProbeResult, String>(
                                id: 'Votes',
                                colorFn: (ProbeResult option, __) => option.color,
                                domainFn: (ProbeResult option, _) => option.name,
                                measureFn: (ProbeResult option, _) => option.count,
                                data: results,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Número total de votos: ${snapshot.data.documents.length}\n b: ${results[0].count} p:${results[1].count}',
                          textAlign: TextAlign.center,
                        ),
                        Row()
                      ],
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProbeResult {
  String name;
  int count;
  charts.Color color;

  ProbeResult(this.name, this.count, this.color);
}
