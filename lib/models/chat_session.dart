import 'message.dart';

/// Represents one full conversation ("chat") in the sidebar history.
///
/// [id]        -> unique session id (used as the storage key / list key)
/// [title]     -> auto-generated from the first user message
/// [messages]  -> all messages exchanged in this session
/// [createdAt] -> used to sort recent chats, newest first
class ChatSession {
  final String id;
  String title;
  final List<Message> messages;
  final DateTime createdAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Generates a short, readable title from the first user message.
  static String titleFromText(String text) {
    final cleaned = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return "New chat";
    return cleaned.length > 34 ? "${cleaned.substring(0, 34)}…" : cleaned;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        messages: (json['messages'] as List<dynamic>)
            .map((m) => Message.fromJson(m as Map<String, dynamic>))
            .toList(),
      );
}
