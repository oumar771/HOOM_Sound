// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/spotify_provider.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  const HomeScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SpotifyProvider>(context, listen: false).loadUserPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HOOM Sound'), centerTitle: true),
      body: Consumer<SpotifyProvider>(
        builder: (context, spotifyProvider, child) {
          if (spotifyProvider.isLoading) return const Center(child: CircularProgressIndicator());
          if (spotifyProvider.errorMessage != null) return Center(child: Text(spotifyProvider.errorMessage!));
          return RefreshIndicator(
            onRefresh: () async => await spotifyProvider.loadUserPlaylists(),
            child: ListView.builder(
              itemCount: spotifyProvider.playlists.length,
              itemBuilder: (context, index) {
                final playlist = spotifyProvider.playlists[index];
                return ListTile(
                  title: Text(playlist['name']),
                  subtitle: Text('${playlist['tracks']['total']} tracks'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: playlist)),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
