import 'package:flutter/material.dart';
import '../services/spotify_auth_service.dart';
import 'spotify_dashboard_page.dart';

class SpotifyAuthPage extends StatefulWidget {
  const SpotifyAuthPage({Key? key}) : super(key: key);

  @override
  _SpotifyAuthPageState createState() => _SpotifyAuthPageState();
}

class _SpotifyAuthPageState extends State<SpotifyAuthPage> {
  final SpotifyAuthService _spotifyAuthService = SpotifyAuthService();
  String? _accessToken;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _authenticateSpotify() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final token = await _spotifyAuthService.authenticate();
      setState(() {
        _accessToken = token;
      });
      // Après authentification, naviguez vers le dashboard Spotify
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SpotifyDashboardPage(accessToken: token),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion Spotify")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _authenticateSpotify,
              child: const Text("Se connecter à Spotify"),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            else if (_accessToken != null)
                SelectableText("Token d'accès : $_accessToken"),
          ],
        ),
      ),
    );
  }
}
