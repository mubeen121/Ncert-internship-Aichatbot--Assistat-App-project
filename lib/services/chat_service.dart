import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Handles all communication with the AI backend (Groq).
///
/// Kept separate from the UI so the app is easy to read and so the
/// backend can be swapped later without touching any screen/widget code.
class ChatService {
  /// Sends the user's [prompt] (plus recent [history] for context) to
  /// Groq and returns the reply text.
  ///
  /// Throws an [Exception] with a friendly message on failure.
  Future<String> sendToAI(
    String prompt,
    List<Map<String, String>> history,
  ) async {
    if (ApiConfig.groqApiKey == "YOUR_GROQ_API_KEY_HERE" ||
        ApiConfig.groqApiKey.isEmpty) {
      throw Exception(
        "No API key found. Please add your free Groq API key in "
        "lib/services/api_config.dart (see the instructions in that file).",
      );
    }

    // OpenAI-style "messages" format: role is "user"/"assistant"/"system"
    final messages = [
      {
        "role": "system",
        "content":
            "You are Ember AI, a helpful, concise assistant inside "
            "a mobile chat app. Keep answers clear and friendly.",
      },
      ...history.map((m) => {
            "role": m["role"] == "user" ? "user" : "assistant",
            "content": m["content"],
          }),
      {"role": "user", "content": prompt},
    ];

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.endpoint),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${ApiConfig.groqApiKey}",
            },
            body: jsonEncode({
              "model": ApiConfig.model,
              "messages": messages,
              "temperature": 0.7,
              "max_tokens": 512,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data["choices"];
        if (choices == null || choices.isEmpty) {
          throw Exception("The AI returned an empty response. Please try again.");
        }
        final reply = choices[0]["message"]?["content"];
        if (reply == null || reply.toString().trim().isEmpty) {
          throw Exception("The AI returned an empty response. Please try again.");
        }
        return reply.toString().trim();
      } else if (response.statusCode == 400) {
        throw Exception("Invalid API key or request. Please check api_config.dart.");
      } else if (response.statusCode == 401) {
        throw Exception("API key rejected. Please check api_config.dart.");
      } else if (response.statusCode == 429) {
        throw Exception("Rate limit reached. Please wait a moment and try again.");
      } else {
        throw Exception(
            "Server error (${response.statusCode}). Please try again shortly.");
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Something went wrong: no internet or the AI is unreachable.");
    }
  }
}
