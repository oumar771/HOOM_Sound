// test/mistralai_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hoom_sound/providers/mistralai_provider.dart';
import 'package:hoom_sound/repositories/mistralai_repository.dart';
import 'package:mockito/mockito.dart';

// Crée un mock pour MistralaiRepository
class MockMistralaiRepository extends Mock implements MistralaiRepository {}

class TestMistralaiProvider extends MistralaiProvider {
  final MistralaiRepository testRepository;
  TestMistralaiProvider(this.testRepository)
      : super(baseUrl: 'dummy', apiKey: 'dummy');

  @override
  Future<void> fetchRecommendation(String prompt) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      recommendation = await testRepository.getRecommendation(prompt);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

void main() {
  group('MistralaiProvider Tests', () {
    late MockMistralaiRepository mockRepo;
    late TestMistralaiProvider provider;

    setUp(() {
      mockRepo = MockMistralaiRepository();
      provider = TestMistralaiProvider(mockRepo);
    });

    test('Successful fetchRecommendation', () async {
      when(mockRepo.getRecommendation("test prompt"))
          .thenAnswer((_) async => "Recommendation text");
      await provider.fetchRecommendation("test prompt");
      expect(provider.recommendation, equals("Recommendation text"));
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, false);
      verify(mockRepo.getRecommendation("test prompt")).called(1);
    });

    test('Failed fetchRecommendation', () async {
      when(mockRepo.getRecommendation("test prompt"))
          .thenThrow(Exception("Fetch error"));
      await provider.fetchRecommendation("test prompt");
      expect(provider.errorMessage, contains("Fetch error"));
      expect(provider.isLoading, false);
      verify(mockRepo.getRecommendation("test prompt")).called(1);
    });
  });
}
