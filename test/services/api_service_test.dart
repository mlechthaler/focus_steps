import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/services/api_service.dart';

void main() {
  group('ApiService', () {
    test('can be instantiated with API key', () {
      final apiService = ApiService(apiKey: 'test-api-key');
      expect(apiService, isNotNull);
    });

    test('can be instantiated with custom model', () {
      final apiService = ApiService(
        apiKey: 'test-api-key',
        model: 'gpt-4',
      );
      expect(apiService, isNotNull);
    });

    test('uses default model when not specified', () {
      final apiService = ApiService(apiKey: 'test-api-key');
      expect(apiService.model, equals('gpt-3.5-turbo'));
    });

    // Note: The actual breakdownTask method would require mocking HTTP requests
    // or integration tests with a real API key. Those tests are omitted here
    // to avoid making actual API calls during unit testing.
    test('breakdownTask method exists and accepts String parameter', () {
      final apiService = ApiService(apiKey: 'test-api-key');
      
      // Verify the method exists and returns a Future
      expect(
        apiService.breakdownTask('Test task'),
        isA<Future<Map<String, dynamic>>>(),
      );
    });
  });
}
