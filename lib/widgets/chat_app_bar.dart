import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom app bar with a black-to-red gradient. Includes a menu
/// (hamburger) button that opens the sidebar drawer, the current
/// chat title, and a "clear/new chat" action.
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;
  final VoidCallback onNewChat;

  const ChatAppBar({
    super.key,
    required this.title,
    required this.onMenuTap,
    required this.onNewChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.appBarGradient,
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: [
              IconButton(
                onPressed: onMenuTap,
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                tooltip: "Menu",
              ),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: onNewChat,
                icon: const Icon(Icons.add_comment_outlined,
                    color: Colors.white70),
                tooltip: "New chat",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
