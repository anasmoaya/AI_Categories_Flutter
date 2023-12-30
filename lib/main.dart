import 'package:flutter/material.dart';
import 'package:project_flutter_ai/views/logingpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_flutter_ai/views/main_activity.dart';
import 'firebase_options.dart'; // This file is generated when you configure Firebase

void main() async {
    WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  ); 
  runApp(const MainApp());
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  MainActivity()
    );
  }
}

