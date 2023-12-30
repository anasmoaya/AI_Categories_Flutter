import 'package:flutter/material.dart';
import 'package:project_flutter_ai/model/activite.dart';

class DetailPage extends StatelessWidget {
  final Activite activite;

  DetailPage(this.activite);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activite.titre),
      ),
      body: Column(
        children: <Widget>[
          Image.network(activite.imageUrl),
          Text(activite.titre),
          Text(activite.lieu),
          Text("${activite.prix}€"),
          // Autres détails ici
        ],
      ),
    );
  }
}
