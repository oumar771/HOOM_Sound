// lib/providers/spotify_provider.dart
import 'package:flutter/material.dart';
import '../repositories/spotify_repository.dart';
import '../services/spotify_api_client.dart';

class SpotifyProvider extends ChangeNotifier {
  final SpotifyRepository repository;
  List<dynamic> playlists = [];
  Map<String, dynamic>? userProfile;
  List<dynamic> likedTracks = [];
  bool isLoading = false;
  String? errorMessage;
  final List<String> _debugLogs = [];

  SpotifyProvider({required String accessToken})
      : repository = SpotifyRepository(
    apiClient: SpotifyApiClient(accessToken: accessToken),
  );

  List<String> get debugLogs => List.unmodifiable(_debugLogs);

  void _addLog(String log) {
    final entry = '${DateTime.now().toIso8601String()} - $log';
    _debugLogs.add(entry);
    print(entry);
  }

  Future<void> loadUserPlaylists() async {
    _addLog("Fetching user playlists...");
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      playlists = await repository.getUserPlaylists();
      _addLog("Fetched ${playlists.length} playlists.");
    } catch (e) {
      errorMessage = e.toString();
      _addLog("Error fetching playlists: $errorMessage");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserProfile() async {
    _addLog("Fetching user profile...");
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      userProfile = await repository.getUserProfile();
      _addLog("Fetched user profile: ${userProfile?['display_name']}");
    } catch (e) {
      errorMessage = e.toString();
      _addLog("Error fetching user profile: $errorMessage");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserLikedTracks() async {
    _addLog("Fetching liked tracks...");
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      likedTracks = await repository.getUserLikedTracks();
      _addLog("Fetched ${likedTracks.length} liked tracks.");
    } catch (e) {
      errorMessage = e.toString();
      _addLog("Error fetching liked tracks: $errorMessage");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String get spotifyStatusSummary {
    final buffer = StringBuffer();
    buffer.writeln("Spotify Status:");
    buffer.writeln("isLoading: $isLoading");
    buffer.writeln("Playlists count: ${playlists.length}");
    buffer.writeln("Liked tracks count: ${likedTracks.length}");
    buffer.writeln("Error: ${errorMessage ?? 'None'}");
    buffer.writeln("Logs:");
    for (var log in _debugLogs) {
      buffer.writeln(log);
    }
    return buffer.toString();
  }
}
