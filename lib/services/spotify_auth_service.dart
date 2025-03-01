import 'dart:async';
import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

/// Service d'authentification Spotify via OAuth.
class SpotifyAuthService {
  final String clientId = "886a235069a54977b556fda4fb2bb282";

  // Nouveau redirect URI, configuré dans Spotify Developer
  final String redirectUri = "hoomsound://callback";

  // Les scopes dont vous avez besoin
  final String scopes = "user-read-private playlist-read-private";

  Future<String> authenticate() async {
    final authUrl =
        "https://accounts.spotify.com/authorize?client_id=$clientId"
        "&response_type=token"
        "&redirect_uri=$redirectUri"
        "&scope=${Uri.encodeComponent(scopes)}";

    // callbackUrlScheme doit être 'hoomsound' si votre schéma est 'hoomsound://'
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: "hoomsound",
    );

    final fragment = Uri.parse(result).fragment;
    final params = Uri.splitQueryString(fragment);
    final accessToken = params["access_token"];

    if (accessToken == null) {
      throw Exception("Token d'accès introuvable dans la réponse.");
    }
    return accessToken;
  }
}
