import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  TextEditingController _titreController = TextEditingController();
  TextEditingController _lieuController = TextEditingController();
  TextEditingController _nbPersonnesController = TextEditingController();
  TextEditingController _prixController = TextEditingController();
  String _selectedCategorie = 'Autres'; // Catégorie sélectionnée par défaut
  final List<String> _categories = ['Sport', 'Divertissement', 'Shopping', 'Autres'];
  XFile? _selectedImage;
  String _imageUrl = ''; // URL de l'image téléchargée
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _isUploading = true;
      });

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('images/${DateTime.now().toString()}');
      UploadTask uploadTask = kIsWeb ? ref.putData(await image.readAsBytes()) : ref.putFile(File(image.path));

      await uploadTask.whenComplete(() async {
        final String downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          _isUploading = false;
          _imageUrl = downloadUrl; // Stocker l'URL téléchargée
        });
      }).catchError((error) {
        setState(() {
          _isUploading = false;
        });
      });
    }
  }

  Future<void> _saveActivity() async {
    if (_isUploading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez attendre la fin du téléchargement de l\'image')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('activites').add({
        'imageUrl': _imageUrl,
        'titre': _titreController.text,
        'lieu': _lieuController.text,
        'prix': double.tryParse(_prixController.text) ?? 0.0,
        'categorie': _selectedCategorie,
        'nbPersonnes': int.tryParse(_nbPersonnesController.text) ?? 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activité ajoutée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de l\'activité')),
      );
    }
  }

Widget _buildImage() {
  if (_isUploading) {
    // Afficher l'indicateur de chargement pendant l'upload
    return Center(child: CircularProgressIndicator());
  } else if (_imageUrl.isNotEmpty) {
    // Afficher l'aperçu de l'image téléchargée
    return Image.network(_imageUrl, width: 100, height: 100); // Taille ajustable
  } else {
    // Afficher le bouton pour sélectionner une image
    return ElevatedButton(
      onPressed: _pickAndUploadImage,
      child: Text('Sélectionner une image'),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une activité'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildImage(),
            TextField(
              controller: _titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            DropdownButton<String>(
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
            TextField(
              controller: _lieuController,
              decoration: InputDecoration(labelText: 'Lieu'),
            ),
            TextField(
              controller: _nbPersonnesController,
              decoration: InputDecoration(labelText: 'Nombre de personnes minimum nécessaire'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _prixController,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _saveActivity,
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
