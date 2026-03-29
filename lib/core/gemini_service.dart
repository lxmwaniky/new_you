import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:logging/logging.dart';

class GeminiService {
  final _logger = Logger('GeminiService');
  late final GenerativeModel _model;
  final String apiKey;

  GeminiService({required this.apiKey}) {
    _logger.info(
      'Initializing GeminiService with API Key: ${apiKey.substring(0, 5)}...',
    );
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
  }

  Future<String?> generateResponse(String prompt) async {
    _logger.info('Generating response for prompt: $prompt');
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        _logger.warning('Gemini returned a null response text.');
        return 'I received an empty response. Please try again.';
      }

      _logger.info('Gemini response received successfully.');
      return response.text;
    } catch (e, stackTrace) {
      _logger.severe(
        'CRITICAL: Error generating Gemini response',
        e,
        stackTrace,
      );
      return 'I am having trouble connecting right now. Error: ${e.toString()}';
    }
  }

  Future<String?> generateCoachingResponse(String userMessage) async {
    _logger.info('User sent message: $userMessage');
    final systemPrompt =
        'You are a supportive and professional coach for "New You", a habit tracker app. '
        'Your goal is to help users build better habits, manage triggers, and achieve their goals. '
        'Keep responses concise, encouraging, and focused on wellness. '
        'If the user seems to be in a crisis, gently remind them to check the "Helplines" tab.';

    final fullPrompt = '$systemPrompt\n\nUser: $userMessage\nCoach:';
    return generateResponse(fullPrompt);
  }
}
