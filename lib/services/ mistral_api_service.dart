import 'dart:convert';
import 'package:http/http.dart' as http;

/// Exception personnalisée pour l'API Mistral.
/// Permet de distinguer clairement les erreurs liées à l'API Mistral.
class MistralApiException implements Exception {
  final String message;
  final int? statusCode;

  MistralApiException(this.message, {this.statusCode});

  @override
  String toString() => "MistralApiException($statusCode): $message";
}

/// Service pour interagir avec l'API Mistral AI.
///
/// Ce service envoie une requête POST à l'endpoint `/v1/chat/completions`
/// pour obtenir une complétion de chat. Il gère également la validation
/// de la réponse et la gestion d'erreurs spécifiques.
class MistralApiService {
  /// Clé d'accès à l'API Mistral (Bearer token).
  final String apiKey;

  /// Indique si les logs de débogage doivent être affichés.
  final bool debug;

  /// URL de base de l'API Mistral.
  final String _baseUrl = "https://api.mistral.ai/v1";

  /// Constructeur du service, nécessite la [apiKey].
  /// [debug] permet d'activer/désactiver les logs.
  MistralApiService({required this.apiKey, this.debug = false});

  /// En-têtes HTTP standards pour l'API Mistral.
  Map<String, String> get _headers => {
    "Authorization": "Bearer $apiKey",
    "Content-Type": "application/json",
  };

  /// Envoie une requête POST pour obtenir une complétion de chat.
  ///
  /// - [messages] : liste de messages sous forme de Map(role, content).
  /// - [model] : nom du modèle à utiliser (ex. "mistral-small-latest").
  /// - [temperature] : contrôle la "créativité" de la réponse.
  /// - [maxTokens] : nombre max de tokens à générer.
  /// - [stream] : si `true`, active le streaming de la réponse (non géré ici).
  ///
  /// Retourne un `Map<String, dynamic>` représentant la réponse JSON complète.
  /// En cas d'erreur, lève une [MistralApiException].
  Future<Map<String, dynamic>> getChatCompletion({
    String model = "mistral-small-latest",
    double temperature = 0.7,
    int maxTokens = 150,
    bool stream = false,
    required List<Map<String, String>> messages,
  }) async {
    final url = Uri.parse("$_baseUrl/chat/completions");

    // Construction du payload de la requête
    final Map<String, dynamic> payload = {
      "model": model,
      "messages": messages,
      "temperature": temperature,
      "max_tokens": maxTokens,
      "stream": stream,
    };

    if (debug) {
      print("Envoi de la requête POST à: $url");
      print("Payload: $payload");
    }

    // Envoi de la requête HTTP POST
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (debug) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }

    // Vérifier le code de statut HTTP
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw MistralApiException(
        "Erreur HTTP: ${response.statusCode} - ${response.body}",
        statusCode: response.statusCode,
      );
    }

    // Vérifier que le Content-Type est JSON
    final contentType = response.headers["content-type"];
    if (contentType == null || !contentType.contains("application/json")) {
      throw MistralApiException(
        "Réponse non-JSON reçue. Content-Type: $contentType",
        statusCode: response.statusCode,
      );
    }

    // Décoder la réponse JSON
    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      return data;
    } else {
      throw MistralApiException("Format JSON inattendu.");
    }
  }
}
