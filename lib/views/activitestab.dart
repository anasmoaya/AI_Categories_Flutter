
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter_ai/model/activite.dart';
import 'package:project_flutter_ai/views/detailpage.dart';

Future<List<Activite>> getActivites() async {
  QuerySnapshot snapshot = 
      await FirebaseFirestore.instance.collection('activites').get();

  return snapshot.docs.map((doc) {
    return Activite(
      imageUrl: doc['image'],
      titre: doc['titre'],
      lieu: doc['lieu'],
      prix: doc['prix'].toDouble(),
    );
  }).toList();
}

class ActivitesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Activite>>(
      future: getActivites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

       if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.error != null) {
          return Center(child: Text("Une erreur s'est produite"));
        }

        if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text("Pas d'activités disponibles"));
        }

        List<Activite> activites = snapshot.data!;
        return ListView.builder(
          itemCount: activites.length,
          itemBuilder: (context, index) {
            Activite activite = activites[index];
            return ListTile(
              leading: Image.network(activite.imageUrl , fit: BoxFit.cover,),
              title: Text(activite.titre),
            
              onTap: () {
                // Naviguer vers une page de détail pour l'activité
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetailPage(activite)));
              },
            );
          },
        );
      },
    );
  }
}
