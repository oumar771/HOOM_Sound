// test/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hoom_sound/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

/// Implémentation factice de PathProviderPlatform pour les tests.
class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.';
  }

  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) async {
    return ['.'];
  }

  @override
  Future<String?> getTemporaryPath() async {
    return '.';
  }
}

void main() {
  // Initialisation de l'environnement Flutter pour les tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  // Configurez les valeurs initiales factices pour SharedPreferences.
  SharedPreferences.setMockInitialValues({});

  // Enregistrez une implémentation factice pour path_provider.
  PathProviderPlatform.instance = FakePathProviderPlatform();

  // Initialiser Supabase avant tous les tests.
  setUpAll(() async {
    await Supabase.initialize(
      url: 'https://qgazccagqcphwjtcwqrc.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnYXpjY2FncWNwaHdqdGN3cXJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4MTYxNDYsImV4cCI6MjA1NjM5MjE0Nn0.oHcsgA2XbCakipD_IijdDR0eOsiGHW0NT1kluH2DkN0',
    );
  });

  // Déclarez AuthService de manière différée.
  late AuthService authService;

  // Initialisez AuthService dans setUp afin qu'il soit créé après l'initialisation de Supabase.
  setUp(() {
    authService = AuthService();
  });

  group('AuthService', () {
    test('Tentative de connexion avec des identifiants invalides génère une exception', () async {
      expect(
            () async => await authService.signIn(
          email: "invalid@test.com",
          password: "wrongPassword",
        ),
        throwsException,
      );
    });

    // Vous pouvez ajouter d'autres tests ici pour signUp, signOut, etc.
  });
}
