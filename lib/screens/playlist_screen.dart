// lib/screens/playlist_screen.dart
import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  final Map<String, dynamic> playlist;
  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistName = playlist['name'] ?? 'Playlist';
    final description = playlist['description'] ?? 'Aucune description disponible';
    final hasImage = playlist['images'] != null && (playlist['images'] as List).isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(playlistName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            hasImage
                ? Image.network(playlist['images'][0]['url'], height: 200, width: double.infinity, fit: BoxFit.cover)
                : Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey,
              child: const Icon(Icons.music_note, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(description, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
