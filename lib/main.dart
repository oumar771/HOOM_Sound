import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';

Future<void> main() async {
  // Initialisation de l'environnement Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Supabase avec l'URL et la clé anonyme
  await Supabase.initialize(
    url: 'https://qgazccagqcphwjtcwqrc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnYXpjY2FncWNwaHdqdGN3cXJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4MTYxNDYsImV4cCI6MjA1NjM5MjE0Nn0.oHcsgA2XbCakipD_IijdDR0eOsiGHW0NT1kluH2DkN0',
  );

  runApp(HoomSoundApp());
}

class HoomSoundApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOOM_Sound',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Définition des routes de l'application
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
      },
    );
  }
}
