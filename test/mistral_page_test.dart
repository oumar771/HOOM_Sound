import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoom_sound/pages/mistral_chat_page.dart';

void main() {
  // Test widget pour la page de chat Mistral
  testWidgets('MistralChatPage displays system message and sends user prompt',
          (WidgetTester tester) async {
        // Utilisation d'une clé API fictive pour les tests
        const dummyApiKey = 'dummy_api_key';

        // Créer un widget MaterialApp contenant la MistralChatPage
        await tester.pumpWidget(
          MaterialApp(
            home: MistralChatPage(apiKey: dummyApiKey),
          ),
        );

        // Vérifier que le message système initial est affiché
        expect(find.text("You are a helpful assistant."), findsOneWidget);

        // Vérifier que le champ de saisie est présent
        expect(find.byType(TextField), findsOneWidget);

        // Entrer un prompt dans le champ de texte
        await tester.enterText(find.byType(TextField), "Qui est le meilleur peintre français ?");
        // Appuyer sur le bouton "Envoyer"
        await tester.tap(find.byType(ElevatedButton));
        // Attendre quelques frames pour le traitement de la requête
        await tester.pump();

        // Comme l'appel réseau est asynchrone, on peut vérifier que l'indicateur de chargement s'affiche
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        // Simuler l'attente de la réponse (ici 2 secondes, à ajuster selon vos besoins)
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Vérifier que l'indicateur de chargement n'est plus affiché
        expect(find.byType(LinearProgressIndicator), findsNothing);

        // Vérifier que le champ de texte est vide après envoi
        expect(find.text("Qui est le meilleur peintre français ?"), findsNothing);

        // On pourrait également vérifier l'affichage d'une réponse ou d'un message d'erreur
        // Par exemple, vérifier qu'un widget contenant une réponse est présent
        // (selon la logique de votre application, vous pouvez adapter cette vérification)
        // expect(find.textContaining("Aucune réponse trouvée."), findsOneWidget);
      });
}
