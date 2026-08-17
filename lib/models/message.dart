/// Represents a single chat message in a conversation.
class Message {
  final String text;
  final bool isUser;
  final bool isError;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    this.isError = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'isError': isError,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        text: json['text'] as String,
        isUser: json['isUser'] as bool,
        isError: json['isError'] as bool? ?? false,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
