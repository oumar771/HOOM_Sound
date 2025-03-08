import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_client.dart';

class AuthRepository {
  final SupabaseClient _client = SupabaseClientService.client;
  final List<String> _debugLogs = [];

  List<String> get debugLogs => List.unmodifiable(_debugLogs);

  void _addLog(String log) {
    final entry = '${DateTime.now().toIso8601String()} - $log';
    _debugLogs.add(entry);
    print(entry);
  }

  Future<dynamic> signInWithSpotify() async {
    _addLog("Tentative de connexion via Spotify...");
    try {
      final response = await _client.auth.signInWithOAuth(
        OAuthProvider.spotify,
        redirectTo: kIsWeb ? null : 'hoomsound://callback',
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
      if (response.session != null) {
        _addLog("Connexion réussie");
        await fetchUserProfile();
      } else {
        _addLog("Connexion échouée : aucune session trouvée");
      }
      return response;
    } catch (e) {
      _addLog("Erreur lors de la connexion avec Spotify: $e");
      throw Exception("Échec de la connexion avec Spotify.");
    }
  }

  Future<void> signOut() async {
    _addLog("Déconnexion en cours...");
    try {
      await _client.auth.signOut();
      _addLog("Déconnexion réussie");
    } catch (e) {
      _addLog("Erreur lors de la déconnexion: $e");
      throw Exception("Échec de la déconnexion.");
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    _addLog("Récupération du profil utilisateur...");
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        _addLog("Aucun utilisateur connecté");
        return null;
      }
      final data = {
        "id": user.id,
        "email": user.email,
        "createdAt": user.createdAt.toIso8601String(),
      };
      _addLog("Profil récupéré: $data");
      return data;
    } catch (e) {
      _addLog("Erreur lors de la récupération du profil: $e");
      throw Exception("Impossible de récupérer le profil utilisateur.");
    }
  }

  Future<bool> isUserLoggedIn() async {
    _addLog("Vérification de l'état de connexion...");
    try {
      final user = _client.auth.currentUser;
      final isLoggedIn = user != null;
      _addLog("Utilisateur connecté: $isLoggedIn");
      return isLoggedIn;
    } catch (e) {
      _addLog("Erreur lors de la vérification de connexion: $e");
      return false;
    }
  }

  String get authStatusSummary {
    final buffer = StringBuffer();
    buffer.writeln("Auth Status:");
    for (final log in _debugLogs) {
      buffer.writeln(log);
    }
    return buffer.toString();
  }
}

extension on bool {
  get session => null;
}

extension on String {
  toIso8601String() {}
}
