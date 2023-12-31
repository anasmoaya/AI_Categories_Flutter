import 'package:flutter/material.dart';
import 'package:project_flutter_ai/userSession.dart';
import 'package:project_flutter_ai/views/activitestab.dart';
import 'package:project_flutter_ai/views/addactivite.dart';
import 'package:project_flutter_ai/views/ai_tab.dart';
import 'package:project_flutter_ai/views/profile.dart';

class MainActivity extends StatefulWidget {
  @override
  MainActivity({Key? key}) : super(key: key);

  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  int _selectedIndex = 0; // Index pour suivre l'onglet sélectionné

  // Liste des widgets pour chaque onglet
  static List<Widget> _widgetOptions = <Widget>[
    ActivitesTab(),
    AddActivityScreen(),
    ImageRecognitionView(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _showSnackBar(context, UserSession.getUsername());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Couleur pour l'élément sélectionné
        unselectedItemColor: Colors.grey, // Couleur pour les éléments non sélectionnés
        onTap: _onItemTapped,
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
