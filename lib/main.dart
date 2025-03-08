import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/spotify_provider.dart';
import 'providers/mistralai_provider.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qgazccagqcphwjtcwqrc.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnYXpjY2FncWNwaHdqdGN3cXJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4MTYxNDYsImV4cCI6MjA1NjM5MjE0Nn0.oHcsgA2XbCakipD_IijdDR0eOsiGHW0NT1kluH2DkN0',

  );

  debugPrint("Supabase initialized successfully");

  runApp(const HOOMSoundApp());
}

class HOOMSoundApp extends StatelessWidget {
  const HOOMSoundApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<SpotifyProvider>(
          create: (_) => SpotifyProvider(accessToken: 'dummyAccessToken'),
        ),
        ChangeNotifierProvider<MistralaiProvider>(
          create: (_) => MistralaiProvider(
            baseUrl: 'https://api.mistralai.com',
            apiKey: 'yourMistralaiApiKey',
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HOOM Sound',
        theme: ThemeData(primaryColor: Colors.green),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(accessToken: 'dummyAccessToken'),
        },
      ),
    );
  }
}
