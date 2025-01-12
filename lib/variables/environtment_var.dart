import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentVar {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}