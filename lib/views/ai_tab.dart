import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class AiTab extends StatefulWidget {
  @override
  _AiTabState createState() => _AiTabState();
}

class _AiTabState extends State<AiTab> {
  File? _image;
  List? _recognitions;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadModel().then((val) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/models/mobilenet_v1_1.0_224_quant.tflite",
        labels: "assets/models/labels_mobilenet_quant_v1_224.txt",
      );
    } catch (e) {
      print("An error occurred while loading the model: $e");
    }
  }

  Future _pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _isLoading = true;
      _image = File(image.path);
    });
    _classifyImage(_image!);
  }

 Future<void> _classifyImage(File image) async {
  var recognitions = await Tflite.runModelOnImage(
    path: image.path,
    imageMean: 127.5,   // Ces valeurs dépendent de votre modèle spécifique
    imageStd: 127.5,    // Utilisez les valeurs appropriées pour votre modèle
    numResults: 1,      // Le nombre de résultats à afficher
    threshold: 0.1,     // Seuil pour les prédictions
    asynch: true
  );
  setState(() {
    _recognitions = recognitions;
    _isLoading = false;
  });
}

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Classifier'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                _image == null ? Container() : Image.file(_image!),
                (_recognitions != null && _recognitions!.isNotEmpty)
                    ? Text(
                        'Prediction: ${_recognitions![0]["label"]}',
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      )
                    : Container()
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.image),
      ),
    );
  }
}
