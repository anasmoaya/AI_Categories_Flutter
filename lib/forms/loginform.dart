import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter_ai/userSession.dart';
import 'package:project_flutter_ai/views/main_activity.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
 @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
            onSaved: (value) => _username = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }


   Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Query Firestore for the username
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _username)
            .get();

        if (userSnapshot.docs.isEmpty) {
          _showSnackBar(context,"User not found");
          return;
        }

        var userData = userSnapshot.docs.first.data();
        var storedPassword= userData['password'];

        if ((_password == storedPassword)) {
          Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (context) => MainActivity()),
);
          _showSnackBar(context,"Login successful");
          UserSession.setUsername(_username);

        
        } else {
          


          _showSnackBar(context , "Incorrect password");
        }
      } catch (e) {
        _showSnackBar(context,"Login failed: ${e.toString()}");
      }
    }
  }


}
  void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

