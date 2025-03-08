import '../services/mistralai_api_client.dart';

class MistralaiRepository {
  final MistralaiApiClient apiClient;
  final List<String> _debugLogs = [];

  MistralaiRepository({required this.apiClient});

  List<String> get debugLogs => List.unmodifiable(_debugLogs);

  void _addLog(String log) {
    final entry = '${DateTime.now().toIso8601String()} - $log';
    _debugLogs.add(entry);
    print(entry);
  }

  Future<String> getRecommendation(String prompt) async {
    _addLog("Sending prompt: $prompt");
    try {
      final recommendation = await apiClient.generateRecommendation(prompt);
      _addLog("Received recommendation: $recommendation");
      return recommendation;
    } catch (e) {
      _addLog("Error for prompt '$prompt': $e");
      throw Exception("Failed to get recommendation for '$prompt'.");
    }
  }

  Future<List<String>> getMultipleRecommendations(List<String> prompts) async {
    _addLog("Sending multiple prompts...");
    final results = await Future.wait(prompts.map((prompt) async {
      try {
        final rec = await getRecommendation(prompt);
        _addLog("Received for '$prompt': $rec");
        return rec;
      } catch (e) {
        _addLog("Error for '$prompt': $e");
        return "Error for '$prompt': $e";
      }
    }));
    return results;
  }

  String get repositoryStatusSummary {
    final buffer = StringBuffer();
    buffer.writeln("Mistralai Repository Status:");
    for (var log in _debugLogs) {
      buffer.writeln(log);
    }
    return buffer.toString();
  }
}
