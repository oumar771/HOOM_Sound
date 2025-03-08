import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyApiClient {
  final String accessToken;
  final bool debug;

  SpotifyApiClient({
    required this.accessToken,
    this.debug = false,
  });

  Future<List<dynamic>> fetchUserPlaylists() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/playlists');
    if (debug) print("Fetching playlists from: $url");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    if (debug) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to fetch playlists (code ${response.statusCode}).');
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final url = Uri.parse('https://api.spotify.com/v1/me');
    if (debug) print("Fetching user profile from: $url");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    if (debug) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch user profile (code ${response.statusCode}).');
    }
  }

  Future<List<dynamic>> fetchUserLikedTracks() async {
    final url = Uri.parse('https://api.spotify.com/v1/me/tracks');
    if (debug) print("Fetching liked tracks from: $url");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    if (debug) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'] ?? [];
    } else {
      throw Exception('Failed to fetch liked tracks (code ${response.statusCode}).');
    }
  }
}
