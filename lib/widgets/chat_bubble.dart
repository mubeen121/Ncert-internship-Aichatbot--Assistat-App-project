import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

/// A single chat bubble — red gradient for the user (right-aligned),
/// dark gradient for the bot (left-aligned).
class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final timeLabel = DateFormat('h:mm a').format(message.timestamp);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser) ...[
              _buildAvatar(isUser: false),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: message.isError
                      ? const LinearGradient(
                          colors: [Color(0xFF3A0000), Color(0xFF1A0000)])
                      : (isUser
                          ? AppColors.userBubbleGradient
                          : AppColors.botBubbleGradient),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  border: message.isError
                      ? Border.all(color: AppColors.crimson, width: 1)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.isError)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.error_outline,
                              size: 15, color: AppColors.brightRed),
                          SizedBox(width: 5),
                          Text(
                            "Error",
                            style: TextStyle(
                              color: AppColors.brightRed,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    if (message.isError) const SizedBox(height: 4),
                    Text(
                      message.text,
                      style: const TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeLabel,
                      style: TextStyle(
                        color: AppColors.softWhite.withOpacity(0.55),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 8),
              _buildAvatar(isUser: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: isUser ? AppColors.deepRed : AppColors.charcoal,
      child: Icon(
        isUser ? Icons.person : Icons.local_fire_department_rounded,
        size: 16,
        color: isUser ? Colors.white : AppColors.brightRed,
      ),
    );
  }
}
