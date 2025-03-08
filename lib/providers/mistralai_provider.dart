// lib/providers/mistralai_provider.dart
import 'package:flutter/material.dart';
import '../repositories/mistralai_repository.dart';
import '../services/mistralai_api_client.dart';

class MistralaiProvider extends ChangeNotifier {
  final MistralaiRepository repository;
  String recommendation = "";
  bool isLoading = false;
  String? errorMessage;
  final List<String> _debugLogs = [];

  MistralaiProvider({required String baseUrl, required String apiKey})
      : repository = MistralaiRepository(
    apiClient: MistralaiApiClient(apiKey: apiKey, baseUrl: baseUrl),
  );

  List<String> get debugLogs => List.unmodifiable(_debugLogs);

  void _addLog(String log) {
    final entry = '${DateTime.now().toIso8601String()} - $log';
    _debugLogs.add(entry);
    print(entry);
  }

  Future<void> fetchRecommendation(String prompt) async {
    _addLog("Fetching recommendation for: $prompt");
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      recommendation = await repository.getRecommendation(prompt);
      _addLog("Received recommendation: $recommendation");
    } catch (e) {
      errorMessage = e.toString();
      _addLog("Error fetching recommendation: $errorMessage");
      throw Exception("Failed to get recommendation.");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMultipleRecommendations(List<String> prompts) async {
    _addLog("Fetching multiple recommendations...");
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await repository.getMultipleRecommendations(prompts);
      recommendation = results.join("\n");
      _addLog("Multiple recommendations received.");
    } catch (e) {
      errorMessage = e.toString();
      _addLog("Error fetching multiple recommendations: $errorMessage");
      throw Exception("Failed to get multiple recommendations.");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearRecommendation() {
    _addLog("Clearing recommendations");
    recommendation = "";
    notifyListeners();
  }

  String get mistralaiStatusSummary {
    final buffer = StringBuffer();
    buffer.writeln("Mistralai Status:");
    buffer.writeln("isLoading: $isLoading");
    buffer.writeln("Recommendation: ${recommendation.isNotEmpty ? recommendation : 'None'}");
    buffer.writeln("Error: ${errorMessage ?? 'None'}");
    buffer.writeln("Logs:");
    for (var log in _debugLogs) {
      buffer.writeln(log);
    }
    return buffer.toString();
  }
}
