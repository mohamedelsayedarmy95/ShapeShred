import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_service.g.dart';

class DeepSeekService {
  final String _apiKey = dotenv.env['DEEPSEEK_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.deepseek.com/chat/completions';

  Future<String> getAIResponse(String prompt) async {
    if (_apiKey.isEmpty) throw Exception('API Key is missing');
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'deepseek-chat', 
        'messages': [{'role': 'user', 'content': prompt}],
      }),
    );
    return jsonDecode(utf8.decode(response.bodyBytes))['choices'][0]['message']['content'];
  }
}

@riverpod
DeepSeekService aiService(Ref ref) => DeepSeekService();
