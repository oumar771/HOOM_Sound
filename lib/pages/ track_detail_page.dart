import 'package:flutter/material.dart';
import '../widgets/audio_player_widget.dart';

class TrackDetailPage extends StatelessWidget {
  final String trackName;
  final String previewUrl; // URL de l'extrait (30s) de la piste

  const TrackDetailPage({Key? key, required this.trackName, required this.previewUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trackName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(trackName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            AudioPlayerWidget(previewUrl: previewUrl),
          ],
        ),
      ),
    );
  }
}
