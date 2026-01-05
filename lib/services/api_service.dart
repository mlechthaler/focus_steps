import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for interacting with OpenAI API to break down tasks into ADHD-friendly steps
class ApiService {
  static const String _openAiUrl = 'https://api.openai.com/v1/chat/completions';
  
  /// API key for OpenAI - should be injected from environment or secure storage
  final String apiKey;
  
  /// Model to use for task breakdown, defaults to gpt-3.5-turbo
  final String model;

  ApiService({
    required this.apiKey,
    this.model = 'gpt-3.5-turbo',
  });

  /// Breaks down a task into extremely small, ADHD-friendly steps
  /// 
  /// Each step should take maximum 5-10 minutes to complete.
  /// Returns a JSON response with the task breakdown.
  /// 
  /// [taskTitle] The title of the task to break down
  /// 
  /// Throws [Exception] if the API request fails or returns an error
  Future<Map<String, dynamic>> breakdownTask(String taskTitle) async {
    final systemPrompt = '''
Du bist ein Assistent, der Menschen mit ADHS hilft, Aufgaben in extrem kleine, überschaubare Schritte zu zerlegen.

Wichtige Regeln:
- Jeder Schritt darf maximal 5-10 Minuten dauern
- Schritte müssen sehr konkret und eindeutig sein
- Keine Überforderung - lieber mehr kleine Schritte als wenige große
- Jeder Schritt sollte ein klares, messbares Ergebnis haben
- Vermeide vage Formulierungen
- Nutze aktivierende, klare Sprache

Gib die Antwort als JSON zurück mit folgendem Format:
{
  "task": "Ursprüngliche Aufgabe",
  "steps": [
    {
      "step_number": 1,
      "title": "Schritt-Titel",
      "description": "Detaillierte Beschreibung",
      "estimated_minutes": 5
    }
  ],
  "total_steps": Anzahl,
  "total_estimated_minutes": Gesamtzeit
}
''';

    final userPrompt = 'Bitte zerlege folgende Aufgabe in ADHS-freundliche Einzelschritte: $taskTitle';

    final requestBody = {
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content': systemPrompt,
        },
        {
          'role': 'user',
          'content': userPrompt,
        }
      ],
      'temperature': 0.7,
      'response_format': {'type': 'json_object'},
    };

    try {
      final response = await http.post(
        Uri.parse(_openAiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Extract the content from OpenAI's response
        final choices = responseData['choices'] as List<dynamic>;
        if (choices.isEmpty) {
          throw Exception('No response from OpenAI API');
        }
        
        final messageContent = choices[0]['message']['content'] as String;
        final taskBreakdown = jsonDecode(messageContent) as Map<String, dynamic>;
        
        return taskBreakdown;
      } else {
        final errorBody = response.body;
        throw Exception(
          'OpenAI API request failed with status ${response.statusCode}: $errorBody'
        );
      }
    } catch (e) {
      throw Exception('Failed to breakdown task: $e');
    }
  }
}
