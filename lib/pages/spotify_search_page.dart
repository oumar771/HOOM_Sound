import 'package:flutter/material.dart';
import '../services/spotify_api_service.dart';
import 'track_detail_page.dart';

class SpotifySearchPage extends StatefulWidget {
  final String accessToken;

  const SpotifySearchPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _SpotifySearchPageState createState() => _SpotifySearchPageState();
}

class _SpotifySearchPageState extends State<SpotifySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _searchResults = [];

  /// Lance la recherche en vérifiant que le champ n'est pas vide.
  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez saisir un terme de recherche.";
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final service = SpotifyApiService(accessToken: widget.accessToken);
    try {
      final results = await service.searchTracks(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Construit un widget pour chaque résultat de recherche.
  Widget _buildResultItem(dynamic track) {
    final trackName = track["name"] ?? "Sans nom";
    final artists = (track["artists"] as List)
        .map((a) => a["name"])
        .join(", ");
    final previewUrl = track["preview_url"];
    final albumArt = track["album"]?["images"] != null &&
        (track["album"]["images"] as List).isNotEmpty
        ? track["album"]["images"][0]["url"]
        : null;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: albumArt != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            albumArt,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        )
            : const Icon(Icons.music_note, size: 50, color: Colors.blueAccent),
        title: Text(
          trackName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          artists,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: previewUrl != null ? const Icon(Icons.play_arrow) : null,
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

  /// Construit le corps principal de la page de recherche.
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    } else if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          "Aucun résultat pour l'instant.",
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return _buildResultItem(_searchResults[index]);
        },
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recherche Spotify"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Champ de recherche avec design moderne
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un titre...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 16),
            // Affichage des résultats ou des messages d'état
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }
}
