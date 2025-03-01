import 'package:flutter/material.dart';
import '../widgets/audio_player_widget.dart';

class TrackDetailPage extends StatelessWidget {
  final String trackName;
  final String previewUrl;
  final String? albumArtUrl;
  final String? artistName;

  const TrackDetailPage({
    Key? key,
    required this.trackName,
    required this.previewUrl,
    this.albumArtUrl,
    this.artistName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trackName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (albumArtUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  albumArtUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Icon(
                Icons.music_note,
                size: 100,
                color: Colors.grey,
              ),
            const SizedBox(height: 16),
            Text(
              trackName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (artistName != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  artistName!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            AudioPlayerWidget(previewUrl: previewUrl),
            const SizedBox(height: 24),
            Text(
              "Écoutez un extrait de 30 secondes",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
