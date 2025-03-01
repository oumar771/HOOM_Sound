import 'package:flutter/material.dart';
import '../services/spotify_api_service.dart';
import 'track_detail_page.dart';

class SpotifyRecommendationPage extends StatefulWidget {
  final String accessToken;

  const SpotifyRecommendationPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _SpotifyRecommendationPageState createState() => _SpotifyRecommendationPageState();
}

class _SpotifyRecommendationPageState extends State<SpotifyRecommendationPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _recommendations = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getRecommendations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final service = SpotifyApiService(accessToken: widget.accessToken);
    try {
      // Exemple : seed_artists ou seed_tracks ou seed_genres
      final recs = await service.getRecommendations(
        seedArtists: ["4NHQUGzhtTLFvgF5SZesLK"], // exemple d'ID artiste
        seedTracks: ["0c6xIDDpzE81m2q797ordA"], // exemple d'ID track
        seedGenres: ["rock"],                   // exemple de genre
      );
      setState(() {
        _recommendations = recs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildTrackItem(dynamic track) {
    final trackName = track["name"] ?? "Sans nom";
    final artists = (track["artists"] as List).map((a) => a["name"]).join(", ");
    final previewUrl = track["preview_url"];
    final albumArt = track["album"]?["images"] != null &&
        (track["album"]["images"] as List).isNotEmpty
        ? track["album"]["images"][0]["url"]
        : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: albumArt != null
            ? Image.network(albumArt, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.music_note),
        title: Text("$trackName\n$artists", maxLines: 2),
        subtitle: previewUrl == null
            ? const Text("Pas d'extrait disponible")
            : const Text("Extrait disponible"),
        onTap: previewUrl == null
            ? null
            : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackDetailPage(
                trackName: trackName,
                previewUrl: previewUrl,
                albumArtUrl: albumArt,
                artistName: artists,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)));
    } else if (_recommendations.isEmpty) {
      return const Center(child: Text("Aucune recommandation pour l'instant."));
    } else {
      return ListView.builder(
        itemCount: _recommendations.length,
        itemBuilder: (context, index) {
          return _buildTrackItem(_recommendations[index]);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommandations"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getRecommendations,
          )
        ],
      ),
      body: _buildBody(),
    );
  }
}
