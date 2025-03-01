import 'package:flutter/material.dart';
import '../services/ mistral_api_service.dart';
import '../widgets/chat_message_widget.dart';

class MistralChatPage extends StatefulWidget {
  final String apiKey;

  const MistralChatPage({Key? key, required this.apiKey}) : super(key: key);

  @override
  _MistralChatPageState createState() => _MistralChatPageState();
}

class _MistralChatPageState extends State<MistralChatPage> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Liste des messages avec rôle et contenu.
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  late MistralApiService _mistralApiService;

  @override
  void initState() {
    super.initState();
    // Initialisation du service Mistral avec la clé API et le mode debug activé.
    _mistralApiService = MistralApiService(apiKey: widget.apiKey, debug: true);
    // Initialiser la conversation avec un message système.
    _messages.add({"role": "system", "content": "You are a helpful assistant."});
  }

  /// Envoie le prompt de l'utilisateur à l'API Mistral et met à jour la conversation.
  Future<void> _sendPrompt() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": prompt});
      _promptController.clear();
      _isLoading = true;
      _errorMessage = null;
    });
    _scrollToBottom();

    try {
      // Envoi de la requête avec la conversation complète.
      final response = await _mistralApiService.getChatCompletion(messages: _messages);
      // Extraction de la réponse de l'assistant.
      final agentResponse = response["choices"]?[0]?["message"]?["content"] ??
          "Aucune réponse trouvée.";
      setState(() {
        _messages.add({"role": "assistant", "content": agentResponse});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  /// Fait défiler la conversation vers le bas.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mistral AI Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Zone d'affichage des messages avec défilement automatique.
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageWidget(
                  role: _messages[index]["role"] ?? "",
                  message: _messages[index]["content"] ?? "",
                );
              },
            ),
          ),
          // Indicateur de chargement
          if (_isLoading) const LinearProgressIndicator(),
          // Affichage de l'erreur
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          // Zone de saisie et bouton Envoyer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: InputDecoration(
                      hintText: "Entrez votre message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => _sendPrompt(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendPrompt,
                  child: const Text("Envoyer"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
