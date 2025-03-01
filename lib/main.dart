import 'package:flutter/material.dart';
import 'package:hoom_sound/pages/%20spotify_auth_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/mistral_chat_page.dart';
import 'pages/signup_page.dart';
import 'pages/spotify_auth_page.dart';
import 'pages/spotify_dashboard_page.dart';
import 'pages/track_detail_page.dart';

Future<void> main() async {
  // Assurez-vous que le binding Flutter est initialisé
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Supabase avec l'URL et la clé anonyme
  await Supabase.initialize(
    url: 'https://qgazccagqcphwjtcwqrc.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnYXpjY2FncWNwaHdqdGN3cXJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4MTYxNDYsImV4cCI6MjA1NjM5MjE0Nn0.oHcsgA2XbCakipD_IijdDR0eOsiGHW0NT1kluH2DkN0',
  );

  // Lancement de l'application
  runApp(const HoomSoundApp());
}

class HoomSoundApp extends StatelessWidget {
  const HoomSoundApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOOM_Sound',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Palette principale
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 4,
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        // Style pour les boutons élevés
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Style de base pour le texte
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      // Route initiale : la page de connexion
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/mistral': (context) => const MistralChatPage(apiKey: '',),
        '/signup': (context) => const SignUpPage(),
        '/spotify': (context) => const SpotifyAuthPage(),
        // La route du dashboard Spotify : le token sera remplacé dynamiquement lors de la navigation
        '/spotifyDashboard': (context) => SpotifyDashboardPage(
          accessToken: "TOKEN_PLACEHOLDER",
        ),
        // Route de détail d'un morceau avec lecteur audio
        '/trackDetail': (context) => const TrackDetailPage(
          trackName: "Exemple de Piste",
          previewUrl: "https://p.scdn.co/mp3-preview/abcdef",
        ),
      },
      // Possibilité de personnaliser les transitions si nécessaire
      onGenerateRoute: (settings) {
        // Retourne null pour utiliser les routes définies ci-dessus
        return null;
      },
    );
  }
}
