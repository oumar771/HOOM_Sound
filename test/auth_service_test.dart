// test/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hoom_sound/services/auth_service.dart';

void main() {
  group('AuthService', () {
    // Instanciation de votre service d'authentification
    final authService = AuthService();

    test('Tentative de connexion avec des identifiants invalides génère une exception', () async {
      // On attend qu'une exception soit lancée avec de mauvaises informations
      expect(
            () async => await authService.signIn("invalid@test.com", "wrongPassword"),
        throwsException,
      );
    });

    // Vous pouvez ajouter d'autres tests ici, par exemple pour l'inscription
    test('Tentative d\'inscription avec des informations valides ne doit pas lancer d\'exception', () async {
      // Pour ce test, il faudra peut-être simuler la réponse de l'API ou utiliser un environnement de test
      // expect(() async => await authService.signUp("valid@test.com", "password123"), returnsNormally);
    });
  });
}
