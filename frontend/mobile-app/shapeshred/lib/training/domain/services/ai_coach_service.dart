import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// AI Coach Service - Handles communication with the LLM API for real-time coaching cues
class AiCoachService {
  final String _apiUrl;
  final String _model;
  final int _maxTokens;
  final Duration _timeout;

  AiCoachService()
      : _apiUrl = 'https://openrouter.ai/api/v1/chat/completions',
        _model = 'deepseek/deepseek-r1', // or try 'deepseek/deepseek-chat' if r1 is not available
        _maxTokens = 30, // Keep responses very short for 1-sentence cues
        _timeout = const Duration(seconds: 10); // Reasonable timeout for mobile API calls

  /// Sends a prompt to the OpenRouter/DeepSeek API and returns the AI-generated coaching cue
  ///
  /// Returns null if the request fails or times out
  Future<String?> getCoachingCue(String prompt) async {
    try {
      // Get API key from environment variables
      final apiKey = dotenv.env['OPENROUTER_API_KEY'] ??
                     dotenv.env['OPENAI_API_KEY']; // Fallback to OpenAI key if OpenRouter not set

      if (apiKey == null || apiKey.isEmpty || apiKey.contains('your_')) {
        debugPrint('AI Coach: API key not configured properly');
        return _getFallbackCue(prompt);
      }

      final uri = Uri.parse(_apiUrl);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'HTTP-Referer': 'https://shapeshred.app', // Optional but recommended
        'X-Title': 'ShapeShred AI Coach', // Optional but recommended
      };

      final requestBody = jsonEncode({
        'model': _model,
        'messages': [
          {
            'role': 'system',
            'content': 'You are an expert fitness coach providing real-time, encouraging form cues. '
                       'Respond with ONLY a single, brief sentence (max 15 words) that gives specific, actionable advice. '
                       'Be positive and motivational. Do not include any explanations or additional text.'
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'max_tokens': _maxTokens,
        'temperature': 0.7, // Balanced creativity and consistency
      });

      final response = await http.post(
        uri,
        headers: headers,
        body: requestBody,
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String? content = responseData['choices'][0]['message']['content'] as String?;
        final String trimmed = content?.trim() ?? '';

        // Clean up the response to ensure it's a single sentence
        final cleaned = _cleanResponse(trimmed);
        if (cleaned.isNotEmpty) {
          return cleaned;
        }
      } else {
        debugPrint('AI Coach: API error ${response.statusCode}: ${response.body}');
      }
    } on SocketException catch (e) {
      debugPrint('AI Coach: Network error - $e');
    } on HttpException catch (e) {
      debugPrint('AI Coach: HTTP error - $e');
    } on FormatException catch (e) {
      debugPrint('AI Coach: Format error - $e');
    } catch (e) {
      debugPrint('AI Coach: Unexpected error - $e');
    }

    // Return a fallback cue if all else fails
    return _getFallbackCue(prompt);
  }

  /// Cleans and validates the AI response to ensure it's a proper cue
  String _cleanResponse(String response) {
    if (response.isEmpty) return '';

    // Remove any quotes or extra formatting
    var cleaned = response.trim();
    if (cleaned.startsWith('"') && cleaned.endsWith('"')) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }
    if (cleaned.startsWith("'") && cleaned.endsWith("'")) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    // Take only the first sentence
    final firstPeriod = cleaned.indexOf('.');
    if (firstPeriod != -1) {
      cleaned = cleaned.substring(0, firstPeriod + 1);
    }

    // Ensure it's not too long
    if (cleaned.length > 100) {
      cleaned = '${cleaned.substring(0, 97)}...';
    }

    return cleaned.trim();
  }

  /// Provides fallback cues when the API is unavailable
  String _getFallbackCue(String prompt) {
    // Extract the flaw from the prompt to give contextual fallback advice
    if (prompt.contains('Not deep enough')) {
      return 'Sit back and down like you\'re sitting in a chair.';
    }
    if (prompt.contains('Knees not bent enough')) {
      return 'Bend your knees more, sink into the squat.';
    }
    if (prompt.contains('Knees too bent')) {
      return 'Control your descent, don\'t rush into the bottom.';
    }
    if (prompt.contains('Chest falling forward')) {
      return 'Chest up, eyes forward, proud chest.';
    }
    if (prompt.contains('Leaning too far back')) {
      return 'Engage your core, stay balanced over your midfoot.';
    }
    if (prompt.contains('Knees caving in')) {
      return 'Push your knees out, align them with your toes.';
    }
    if (prompt.contains('form looks good')) {
      return 'Great form! Keep it consistent.';
    }

    // Generic fallback
    return 'Stay tight and controlled through the movement.';
  }
}