import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service pour interagir avec l'API Spotify.
///
/// Ce service gère la récupération du profil utilisateur, des playlists,
/// des morceaux d'une playlist, la recherche de pistes et l'obtention de recommandations.
/// Assurez-vous que le token d'accès (accessToken) est valide et possède les scopes requis.
class SpotifyApiService {
  /// Le token d'accès Spotify (Bearer token).
  final String accessToken;

  /// Constructeur qui requiert un token d'accès valide.
  SpotifyApiService({required this.accessToken});

  /// Renvoie les en-têtes HTTP pour l'authentification.
  Map<String, String> get _headers => {
    "Authorization": "Bearer $accessToken",
    "Content-Type": "application/json",
  };

  /// Récupère le profil de l'utilisateur connecté.
  ///
  /// Retourne une Map contenant les informations du profil (display_name, email, images, etc.).
  Future<Map<String, dynamic>> getUserProfile() async {
    final url = Uri.parse("https://api.spotify.com/v1/me");
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception("Erreur lors de la récupération du profil : ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Échec de la récupération du profil : $e");
    }
  }

  /// Récupère la liste des playlists de l'utilisateur.
  ///
  /// Retourne une List contenant les playlists.
  Future<List<dynamic>> getUserPlaylists() async {
    final url = Uri.parse("https://api.spotify.com/v1/me/playlists");
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.containsKey("items")) {
          return data["items"] as List<dynamic>;
        }
        return [];
      } else {
        throw Exception("Erreur lors de la récupération des playlists : ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Échec de la récupération des playlists : $e");
    }
  }

  /// Récupère les morceaux d'une playlist donnée par son [playlistId].
  ///
  /// Retourne une List contenant les morceaux de la playlist.
  Future<List<dynamic>> getPlaylistTracks(String playlistId) async {
    final url = Uri.parse("https://api.spotify.com/v1/playlists/$playlistId/tracks");
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.containsKey("items")) {
          return data["items"] as List<dynamic>;
        }
        return [];
      } else {
        throw Exception("Erreur lors de la récupération des morceaux de la playlist : ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Échec de la récupération des morceaux de la playlist : $e");
    }
  }

  /// Recherche des pistes via le paramètre [query].
  ///
  /// Retourne une List contenant les pistes trouvées.
  Future<List<dynamic>> searchTracks(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse("https://api.spotify.com/v1/search?q=$encodedQuery&type=track");
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data["tracks"] != null && data["tracks"]["items"] != null) {
          return data["tracks"]["items"] as List<dynamic>;
        }
        return [];
      } else {
        throw Exception("Erreur lors de la recherche : ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Échec de la recherche : $e");
    }
  }

  /// Récupère des recommandations basées sur des seeds (artistes, pistes et genres).
  ///
  /// [seedArtists], [seedTracks] et [seedGenres] doivent être des listes d'ID (String).
  /// Retourne une List contenant les pistes recommandées.
  Future<List<dynamic>> getRecommendations({
    List<String> seedArtists = const [],
    List<String> seedTracks = const [],
    List<String> seedGenres = const [],
  }) async {
    final artists = seedArtists.join(',');
    final tracks = seedTracks.join(',');
    final genres = seedGenres.join(',');

    final url = Uri.parse(
      "https://api.spotify.com/v1/recommendations?seed_artists=$artists&seed_tracks=$tracks&seed_genres=$genres",
    );
    try {
      final response = await http.get(url, headers: _headers);
      // Pour le débogage, vous pouvez décommenter les lignes suivantes :
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data["tracks"] != null) {
          return data["tracks"] as List<dynamic>;
        }
        return [];
      } else {
        throw Exception("Erreur lors de la récupération des recommandations : ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Échec de la récupération des recommandations : $e");
    }
  }
}
