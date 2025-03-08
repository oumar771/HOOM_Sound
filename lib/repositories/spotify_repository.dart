import 'package:hoom_sound/services/spotify_api_client.dart';

class SpotifyRepository {
  final SpotifyApiClient apiClient;
  final List<String> _debugLogs = [];

  SpotifyRepository({required this.apiClient});

  List<String> get debugLogs => List.unmodifiable(_debugLogs);

  void _addLog(String log) {
    final entry = '${DateTime.now().toIso8601String()} - $log';
    _debugLogs.add(entry);
    print(entry);
  }

  Future<List<dynamic>> getUserPlaylists() async {
    _addLog("Fetching playlists...");
    try {
      final playlists = await apiClient.fetchUserPlaylists();
      _addLog("Fetched ${playlists.length} playlists.");
      return playlists;
    } catch (e) {
      _addLog("Error fetching playlists: $e");
      throw Exception("Failed to fetch playlists: $e");
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    _addLog("Fetching user profile...");
    try {
      final profile = await apiClient.fetchUserProfile();
      _addLog("Fetched profile: ${profile['display_name']}");
      return profile;
    } catch (e) {
      _addLog("Error fetching profile: $e");
      throw Exception("Failed to fetch user profile: $e");
    }
  }

  Future<List<dynamic>> getUserLikedTracks() async {
    _addLog("Fetching liked tracks...");
    try {
      final tracks = await apiClient.fetchUserLikedTracks();
      _addLog("Fetched ${tracks.length} liked tracks.");
      return tracks;
    } catch (e) {
      _addLog("Error fetching liked tracks: $e");
      throw Exception("Failed to fetch liked tracks: $e");
    }
  }

  String get repositoryStatusSummary {
    final buffer = StringBuffer();
    buffer.writeln("Spotify Repository Status:");
    for (var log in _debugLogs) {
      buffer.writeln(log);
    }
    return buffer.toString();
  }
}
