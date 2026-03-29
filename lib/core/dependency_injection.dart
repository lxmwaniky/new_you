import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'gemini_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Register GeminiService
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  print(
    'DEBUG: Loading API Key from .env: ${apiKey.isEmpty ? "EMPTY!" : "FOUND (Length: ${apiKey.length})"}',
  );
  getIt.registerLazySingleton<GeminiService>(
    () => GeminiService(apiKey: apiKey),
  );

  // In the future, we can register Repositories here
  // getIt.registerLazySingleton<JournalRepository>(() => JournalRepository());
}
