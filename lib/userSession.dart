class UserSession {
  static String username = '';
  
  // Méthodes pour définir et obtenir le nom d'utilisateur
  static void setUsername(String newUsername) {
    username = newUsername;
  }

  static String getUsername() {
    return username;
  }
}
