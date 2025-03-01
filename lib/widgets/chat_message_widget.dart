import 'package:flutter/material.dart';

/// Widget pour afficher un message de chat.
///
/// Ce widget affiche le contenu d'un message avec un style différent
/// selon le rôle (user, assistant, system).
class ChatMessageWidget extends StatelessWidget {
  /// Le rôle de l'expéditeur (ex. "user", "assistant", "system").
  final String role;

  /// Le contenu textuel du message.
  final String message;

  /// Optionnel : l'horodatage du message.
  final DateTime? timestamp;

  const ChatMessageWidget({
    Key? key,
    required this.role,
    required this.message,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Vérifier que role n'est pas vide pour éviter une erreur sur substring.
    final String displayLetter = role.isNotEmpty ? role.substring(0, 1).toUpperCase() : "?";

    // Détermine si le message est envoyé par l'utilisateur.
    final bool isUser = role.toLowerCase() == "user";
    // Détermine si le message provient de l'assistant.
    final bool isAssistant = role.toLowerCase() == "assistant";
    // Pour les messages système ou autres, on peut appliquer un style neutre.
    final bool isSystem = role.toLowerCase() == "system";

    // Définir les couleurs en fonction du rôle.
    Color bubbleColor;
    Color textColor;
    if (isUser) {
      bubbleColor = Colors.blueAccent;
      textColor = Colors.white;
    } else if (isAssistant) {
      bubbleColor = Colors.grey.shade300;
      textColor = Colors.black87;
    } else {
      bubbleColor = Colors.orange.shade100;
      textColor = Colors.black87;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: isAssistant ? Colors.grey.shade500 : Colors.orange,
              child: Text(
                displayLetter,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
                if (timestamp != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "${timestamp!.hour.toString().padLeft(2, '0')}:${timestamp!.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                displayLetter,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
