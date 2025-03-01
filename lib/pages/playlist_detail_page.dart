import 'package:flutter/material.dart';
import '../services/spotify_api_service.dart';
import 'track_detail_page.dart';

class PlaylistDetailPage extends StatefulWidget {
  final String accessToken;
  final String playlistId;
  final String playlistName;

  const PlaylistDetailPage({
    Key? key,
    required this.accessToken,
    required this.playlistId,
    required this.playlistName,
  }) : super(key: key);

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic>? _tracks;

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  Future<void> _fetchTracks() async {
    final service = SpotifyApiService(accessToken: widget.accessToken);
    try {
      final items = await service.getPlaylistTracks(widget.playlistId);
      setState(() {
        _tracks = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildTrackItem(dynamic trackItem) {
    // trackItem["track"] contient les infos du morceau
    final track = trackItem["track"];
    if (track == null) {
      return const SizedBox.shrink();
    }
    final trackName = track["name"] ?? "Sans nom";
    final artists = (track["artists"] as List).map((a) => a["name"]).join(", ");
    final previewUrl = track["preview_url"];
    final albumArt = track["album"]?["images"] != null &&
        (track["album"]["images"] as List).isNotEmpty
        ? track["album"]["images"][0]["url"]
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      )
          : _tracks == null || _tracks!.isEmpty
          ? const Center(child: Text("Aucun morceau trouvé dans cette playlist."))
          : ListView.builder(
        itemCount: _tracks!.length,
        itemBuilder: (context, index) {
          final trackItem = _tracks![index];
          return _buildTrackItem(trackItem);
        },
      ),
    );
  }
}
