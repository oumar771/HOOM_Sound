import 'dart:convert';
import 'package:http/http.dart' as http;

class MistralaiApiClient {
  final String apiKey;
  final String baseUrl;
  final bool debug;

  MistralaiApiClient({
    required this.apiKey,
    this.baseUrl = 'https://api.mistralai.ai/v1/chat/completions',
    this.debug = false,
  });

  Future<String> generateRecommendation(String prompt, {String model = "mistral-medium"}) async {
    final url = Uri.parse(baseUrl);
    final bodyPayload = {
      "model": model,
      "messages": [
        {"role": "system", "content": "Tu es un expert en musique."},
        {"role": "user", "content": prompt}
      ]
    };

    if (debug) {
      print("Request URL: $url");
      print("Request Headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'}");
      print("Request Body: $bodyPayload");
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyPayload),
      );

      if (debug) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content;
      } else {
        throw Exception("Generation error (code ${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      if (debug) {
        print("Exception during recommendation generation: $e");
      }
      rethrow;
    }
  }
}
