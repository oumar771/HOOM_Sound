// test/spotify_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hoom_sound/providers/spotify_provider.dart';
import 'package:hoom_sound/repositories/spotify_repository.dart';
import 'package:mockito/mockito.dart';

// Crée un mock pour SpotifyRepository
class MockSpotifyRepository extends Mock implements SpotifyRepository {}

class TestSpotifyProvider extends SpotifyProvider {
  final SpotifyRepository testRepository;
  TestSpotifyProvider(String accessToken, this.testRepository)
      : super(accessToken: accessToken);

  @override
  Future<void> loadUserPlaylists() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      playlists = await testRepository.getUserPlaylists();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> loadUserProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      userProfile = await testRepository.getUserProfile();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> loadUserLikedTracks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      likedTracks = await testRepository.getUserLikedTracks();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

void main() {
  group('SpotifyProvider Tests', () {
    late MockSpotifyRepository mockRepo;
    late TestSpotifyProvider provider;

    setUp(() {
      mockRepo = MockSpotifyRepository();
      provider = TestSpotifyProvider("dummyAccessToken", mockRepo);
    });

    test('loadUserPlaylists success', () async {
      when(mockRepo.getUserPlaylists()).thenAnswer((_) async => ['playlist1', 'playlist2']);
      await provider.loadUserPlaylists();
      expect(provider.playlists, equals(['playlist1', 'playlist2']));
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, false);
      verify(mockRepo.getUserPlaylists()).called(1);
    });

    test('loadUserProfile success', () async {
      when(mockRepo.getUserProfile()).thenAnswer((_) async => {'display_name': 'Test User'});
      await provider.loadUserProfile();
      expect(provider.userProfile?['display_name'], equals('Test User'));
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, false);
      verify(mockRepo.getUserProfile()).called(1);
    });

    test('loadUserLikedTracks success', () async {
      when(mockRepo.getUserLikedTracks()).thenAnswer((_) async => ['track1', 'track2']);
      await provider.loadUserLikedTracks();
      expect(provider.likedTracks, equals(['track1', 'track2']));
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, false);
      verify(mockRepo.getUserLikedTracks()).called(1);
    });
  });
}
