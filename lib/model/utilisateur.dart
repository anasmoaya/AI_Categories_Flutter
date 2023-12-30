class User {
  String username;
  String password; // Remarque : gérer le mot de passe de manière sécurisée
  DateTime birthday;
  String address;

  User({required this.username, required this.password, required this.birthday, required this.address});

  // Convertir un document Firebase en un objet User
  factory User.fromFirestore(Map<String, dynamic> doc) {
    return User(
      username: doc['username'] as String,
      password: doc['password'] as String, // Assurez-vous de gérer ceci de manière appropriée
      birthday: DateTime.parse(doc['birthday'] as String),
      address: doc['address'] as String,
    );
  }

  // Convertir l'objet User en un document Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'password': password, // Encore une fois, soyez prudent avec le mot de passe
      'birthday': birthday.toIso8601String(),
      'address': address,
    };
  }
}
