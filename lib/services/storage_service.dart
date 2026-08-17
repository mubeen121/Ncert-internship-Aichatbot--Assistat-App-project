import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_session.dart';

/// Handles saving/loading the list of chat sessions (the sidebar's
/// "Recent" history) to local device storage, so history survives
/// app restarts — not just the current session.
class ChatStorageService {
  static const _storageKey = 'ember_ai_chat_sessions';

  Future<List<ChatSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      final sessions = decoded
          .map((e) => ChatSession.fromJson(e as Map<String, dynamic>))
          .toList();
      // Newest first
      sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return sessions;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSessions(List<ChatSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
