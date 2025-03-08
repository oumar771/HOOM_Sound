// lib/models/playlist.dart

class Playlist {
  final String id;
  final String name;
  final String description;
  final int trackCount;
  final String imageUrl;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.trackCount,
    required this.imageUrl,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Nom non disponible',
      description: json['description'] ?? 'Aucune description',
      trackCount: json['tracks'] != null ? json['tracks']['total'] as int : 0,
      imageUrl: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0]['url'] as String
          : '',
    );
  }
}
