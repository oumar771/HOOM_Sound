import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoom_sound/pages/login_page.dart';

void main() {
  testWidgets('Vérifie que les messages d\'erreur apparaissent pour les champs vides', (WidgetTester tester) async {
    // Créez un widget MaterialApp pour envelopper la LoginPage
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Tapez sur le bouton "Se connecter"
    final loginButton = find.text('Se connecter');
    await tester.tap(loginButton);
    await tester.pump();

    // Vérifiez que les messages d'erreur apparaissent
    expect(find.text('Veuillez entrer votre email'), findsOneWidget);
    expect(find.text('Veuillez entrer votre mot de passe'), findsOneWidget);
  });
}
