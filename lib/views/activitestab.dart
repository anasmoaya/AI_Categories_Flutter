import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter_ai/model/activite.dart';
import 'package:project_flutter_ai/views/detailpage.dart';

class ActivitesTab extends StatefulWidget {
  @override
  _ActivitesTabState createState() => _ActivitesTabState();
}

class _ActivitesTabState extends State<ActivitesTab> {
  String _selectedCategorie = 'Toutes'; // Catégorie sélectionnée par défaut
  final List<String> _categories = ['Toutes', 'Sport', 'Divertissement', 'Shopping', 'Autres'];

  Future<List<Activite>> getActivites() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('activites').get();

  return snapshot.docs.map((doc) {
    // Assurez-vous de convertir correctement les champs en double ou en int
    return Activite(
      imageUrl: doc['imageUrl'] as String,
      titre: doc['titre'] as String,
      lieu: doc['lieu'] as String,
      prix: (doc['prix'] as num).toDouble(),
      categorie: doc['categorie'] as String,
      nbPersonnes: (doc['nbPersonnes'] as num).toInt(),
    );
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedCategorie,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategorie = newValue!;
              });
            },
            items: _categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Flexible(
          child: FutureBuilder<List<Activite>>(
            future: getActivites(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.error != null) {
                return Center(child: Text(snapshot.error.toString()));
              }

              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text("Pas d'activités disponibles"));
              }

              List<Activite> activites = snapshot.data!;
              if (_selectedCategorie != 'Toutes') {
                activites = activites.where((activite) => activite.categorie == _selectedCategorie).toList();
              }

              return ListView.builder(
                itemCount: activites.length,
                itemBuilder: (context, index) {
                  Activite activite = activites[index];
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailPage(activite)),
                        );
                      },
                      child: Column(
                        children: [
                          Image.network(activite.imageUrl, fit: BoxFit.cover, height: 200),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(activite.titre, style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(8),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
