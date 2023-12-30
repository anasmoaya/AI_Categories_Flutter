import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter_ai/model/utilisateur.dart';

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

  Future<void> _loadUserData() async {
    // Remplacez par votre logique de récupération des données utilisateur
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Utilisateur user = Utilisateur.fromFirestore(userDoc);

    setState(() {
      _usernameController.text = user.username;
      _passwordController.text = user.password; // Assurez-vous de gérer le mot de passe de manière sécurisée
      _birthdayController.text = DateFormat('yyyy-MM-dd').format(user.birthday); // Utilisez le format que vous préférez
      _addressController.text = user.address;
    });
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
              readOnly: true, // Rend le champ en lecture seule
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
                // Fonction pour sauvegarder les données
              },
              child: Text('Valider'),
            ),
            ElevatedButton(
              onPressed: () {
                // Fonction pour se déconnecter
                Navigator.pop(context); // Retour à l'écran de connexion
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
