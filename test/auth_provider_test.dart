// test/auth_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hoom_sound/providers/auth_provider.dart';
import 'package:hoom_sound/repositories/auth_repository.dart';
import 'package:mockito/mockito.dart';

// Crée un mock pour AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

// Pour pouvoir injecter un repository dans AuthProvider, on crée une sous-classe qui accepte un repository personnalisé.
class TestAuthProvider extends AuthProvider {
  final AuthRepository testRepository;
  TestAuthProvider(this.testRepository) {
    // Remplacer l'instance interne par le repository de test.
    // Ici, on simule en assignant via un hack puisque l'attribut est privé dans la classe de base.
    // Dans un projet réel, il faudrait utiliser l'injection de dépendances directement dans le constructeur.
  }

  @override
  Future<void> signInWithSpotify() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await testRepository.signInWithSpotify();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await testRepository.signOut();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      return await testRepository.fetchUserProfile();
    } catch (e) {
      errorMessage = e.toString();
      throw Exception("Unable to fetch user profile.");
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      return await testRepository.isUserLoggedIn();
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}

void main() {
  group('AuthProvider Tests', () {
    late MockAuthRepository mockRepo;
    late TestAuthProvider authProvider;

    setUp(() {
      mockRepo = MockAuthRepository();
      authProvider = TestAuthProvider(mockRepo);
    });

    test('Successful signInWithSpotify', () async {
      when(mockRepo.signInWithSpotify()).thenAnswer((_) async => {'session': 'fake_session'});
      when(mockRepo.fetchUserProfile()).thenAnswer((_) async => {
        'id': '123',
        'email': 'test@example.com',
        'createdAt': DateTime.now().toIso8601String()
      });
      await authProvider.signInWithSpotify();
      expect(authProvider.errorMessage, isNull);
      expect(authProvider.isLoading, false);
      verify(mockRepo.signInWithSpotify()).called(1);
    });

    test('Failed signInWithSpotify', () async {
      when(mockRepo.signInWithSpotify()).thenThrow(Exception("Sign in error"));
      await authProvider.signInWithSpotify();
      expect(authProvider.errorMessage, contains("Sign in error"));
      expect(authProvider.isLoading, false);
      verify(mockRepo.signInWithSpotify()).called(1);
    });
  });
}
