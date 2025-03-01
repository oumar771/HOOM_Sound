import 'package:flutter/material.dart';
import '../services/spotify_api_service.dart';
import 'playlist_detail_page.dart';
import 'spotify_search_page.dart';
import 'spotify_recommendation_page.dart';

class SpotifyDashboardPage extends StatefulWidget {
  final String accessToken;

  const SpotifyDashboardPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _SpotifyDashboardPageState createState() => _SpotifyDashboardPageState();
}

class _SpotifyDashboardPageState extends State<SpotifyDashboardPage> {
  Map<String, dynamic>? _profile;
  List<dynamic>? _playlists;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSpotifyData();
  }

  /// Récupère le profil utilisateur et la liste des playlists.
  Future<void> _fetchSpotifyData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final spotifyApiService = SpotifyApiService(accessToken: widget.accessToken);
    try {
      final profile = await spotifyApiService.getUserProfile();
      final playlists = await spotifyApiService.getUserPlaylists();
      setState(() {
        _profile = profile;
        _playlists = playlists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Construit la section du profil (photo, nom, email).
  Widget _buildProfileSection() {
    if (_profile == null) return const SizedBox.shrink();

    return Row(
      children: [
        if (_profile!["images"] != null && (_profile!["images"] as List).isNotEmpty)
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(_profile!["images"][0]["url"]),
          )
        else
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _profile!["display_name"] ?? "Nom inconnu",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                _profile!["email"] ?? "Email inconnu",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construit une carte affichant une playlist.
  Widget _buildPlaylistCard(dynamic playlist) {
    final playlistId = playlist["id"];
    final playlistName = playlist["name"] ?? "Playlist inconnue";
    final images = playlist["images"] as List?;
    final imageUrl = (images != null && images.isNotEmpty) ? images[0]["url"] : null;
    final trackCount = playlist["tracks"]["total"] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Naviguer vers la page de détail de la playlist
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistDetailPage(
                accessToken: widget.accessToken,
                playlistId: playlistId,
                playlistName: playlistName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const Icon(Icons.music_note, size: 60, color: Colors.blueAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlistName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Morceaux : $trackCount",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la section affichant toutes les playlists.
  Widget _buildPlaylistSection() {
    if (_playlists == null || _playlists!.isEmpty) {
      return const Center(child: Text("Aucune playlist trouvée."));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _playlists!.length,
      itemBuilder: (context, index) {
        return _buildPlaylistCard(_playlists![index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spotify Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSpotifyData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 24),
            // Boutons pour accéder à la recherche et aux recommandations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text("Rechercher"),
                  onPressed: () {
                    // Naviguer vers la page de recherche
                    Navigator.pushNamed(
                      context,
                      '/spotifySearch',
                      arguments: widget.accessToken,
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.star),
                  label: const Text("Recommandations"),
                  onPressed: () {
                    // Naviguer vers la page de recommandations
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpotifyRecommendationPage(
                          accessToken: widget.accessToken,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Mes Playlists",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPlaylistSection(),
          ],
        ),
      ),
    );
  }
}
