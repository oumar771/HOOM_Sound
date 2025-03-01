import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DashboardPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  Future<void> _signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      // Retour à la page de connexion après déconnexion
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Afficher une erreur si nécessaire
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Bienvenue dans HOOM_Sound !',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
