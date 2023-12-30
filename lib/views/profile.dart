import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_flutter_ai/userSession.dart';
import 'package:project_flutter_ai/views/logingpage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Déclarez les contrôleurs de texte pour les champs de formulaire
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _updateUserData() async {
  String username = UserSession.getUsername();

  // Créez un Map avec les données à mettre à jour
  Map<String, dynamic> updatedData = {
    'birthday': _birthdayController.text,
    'address': _addressController.text,
    'username' : _usernameController.text,
    'password' : _passwordController.text
  };

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: username)
    .get();

if (snapshot.docs.isNotEmpty) {
  String docId = snapshot.docs.first.id;
   await FirebaseFirestore.instance
        .collection('users')
        .doc(docId) 
        .update(updatedData); 
}
   

    // Afficher un message de succès ou effectuer d'autres actions après la mise à jour
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Informations mises à jour avec succès')),
    );
  } catch (e) {
    // Gérer les erreurs de mise à jour
    print('Erreur lors de la mise à jour: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la mise à jour')),
    );
  }
}







  Future<void> _loadUserData() async {
     String username = UserSession.getUsername();

  // Ici, interrogez Firestore pour obtenir les informations de l'utilisateur
  // en utilisant le nom d'utilisateur
  try{
    QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('username', isEqualTo: username)
      .get();

      if (snapshot.docs.isNotEmpty) {
  var userDoc = snapshot.docs.first.data() as Map<String, dynamic>; // Assurez-vous que c'est bien un Map

  setState(() {
    _usernameController.text = userDoc['username'] as String? ?? '';
    _birthdayController.text = userDoc['birthday'] as String? ?? '';
    _passwordController.text = userDoc['password'] as String? ?? ''; // Récupération du mot de passe
    _addressController.text = userDoc['address'] as String? ?? '';
  });

  }
  


}catch(e){
  print(e);

  }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true, // Offusque le mot de passe
            ),
            TextField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Date de naissance'),
              // Ajouter un sélecteur de date si nécessaire
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Adresse'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateUserData();
              },
              child: Text('Valider'),
            ),
            ElevatedButton(
              onPressed: () {
                // Fonction pour se déconnecter
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
