import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageRecognitionView extends StatefulWidget {
  @override
  _ImageRecognitionViewState createState() => _ImageRecognitionViewState();
}

class _ImageRecognitionViewState extends State<ImageRecognitionView> {
  File? _image;
  String? _result;

  Future pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      classifyImage(File(image.path));
    }
  }

Future classifyImage(File image) async {
  String url = "https://api.imagga.com/v2/tags";
  String authorization = "Basic YWNjXzc4OTA4MmNmMDM0MzFjNTo0Y2QyZDY2MjMxNTk1OTIwYmFkOTI3OWY5MTljYjNiNw==";
  
  var request = http.MultipartRequest('POST', Uri.parse(url))
    ..headers.addAll({"Authorization": authorization})
    ..files.add(await http.MultipartFile.fromPath('image', image.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    final jsonResponse = json.decode(respStr);
    final tags = jsonResponse['result']['tags'] as List;
    
    if (tags.isNotEmpty) {
      // Récupère uniquement les trois premiers tags
      List<String> topTags = [];
      for (var i = 0; i < tags.length && i < 3; i++) {
        topTags.add("${tags[i]['tag']['en']} (${tags[i]['confidence'].toStringAsFixed(0)}%)");
      }
      setState(() {
        _result = topTags.join(', ');
      });
    }
  } else {
    setState(() {
      _result = "Erreur de prédiction : ${response.statusCode}";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reconnaissance d'Images"),
      ),
      body: Column(
        children: <Widget>[
          _image == null ? Text("Aucune image sélectionnée") : Image.file(_image!),
          Text(_result ?? "Aucun résultat"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
