import 'package:flutter/material.dart';
import '../models/chat_session.dart';
import '../theme/app_theme.dart';
import 'app_logo.dart';

/// The app's sidebar (Drawer): Home button, New Chat button, and a
/// scrollable "Recent" list of past chat sessions. Each recent item
/// reveals a delete icon on hover (desktop/web) so the list stays
/// clean until the user actually wants to remove something.
class SidebarDrawer extends StatelessWidget {
  final List<ChatSession> sessions;
  final String? activeSessionId;
  final VoidCallback onHomeTap;
  final VoidCallback onNewChatTap;
  final void Function(ChatSession session) onSessionTap;
  final void Function(ChatSession session) onDeleteTap;

  const SidebarDrawer({
    super.key,
    required this.sessions,
    required this.activeSessionId,
    required this.onHomeTap,
    required this.onNewChatTap,
    required this.onSessionTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.sidebarBlack,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header — logo + brand name
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                children: [
                  const AppLogo(size: 42, glowStrength: 0.45),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Ember AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF2A0000), height: 1),
            const SizedBox(height: 8),

            // Home
            _SidebarActionTile(
              icon: Icons.home_rounded,
              label: "Home",
              onTap: onHomeTap,
            ),
            // New chat
            _SidebarActionTile(
              icon: Icons.add_circle_outline_rounded,
              label: "New chat",
              onTap: onNewChatTap,
            ),

            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "RECENT",
                style: TextStyle(
                  color: AppColors.faintGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 6),

            Expanded(
              child: sessions.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "No chats yet — start a new one!",
                        style: TextStyle(
                          color: AppColors.faintGrey,
                          fontSize: 13,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return _SessionTile(
                          session: session,
                          isActive: session.id == activeSessionId,
                          onTap: () => onSessionTap(session),
                          onDelete: () => onDeleteTap(session),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SidebarActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brightRed, size: 21),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.softWhite,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single recent-chat row. Reveals a delete icon when hovered
/// (desktop/web via MouseRegion); on touch devices it stays subtly
/// visible at low opacity so it's still reachable by tap.
class _SessionTile extends StatefulWidget {
  final ChatSession session;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SessionTile({
    required this.session,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_SessionTile> createState() => _SessionTileState();
}

class _SessionTileState extends State<_SessionTile> {
  bool _hovered = false;
  bool _revealed = false; // toggled by long-press on touch devices

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: widget.isActive
            ? AppColors.deepRed.withOpacity(0.18)
            : Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_revealed) {
              setState(() => _revealed = false);
            } else {
              widget.onTap();
            }
          },
          // Long-press reveals the delete icon on touch devices,
          // where hover events don't exist.
          onLongPress: () => setState(() => _revealed = !_revealed),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 17,
                  color: widget.isActive
                      ? AppColors.brightRed
                      : AppColors.mutedGrey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.session.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.isActive
                          ? AppColors.softWhite
                          : AppColors.mutedGrey,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: (_hovered || _revealed) ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: IgnorePointer(
                    ignoring: !(_hovered || _revealed),
                    child: GestureDetector(
                      onTap: widget.onDelete,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: AppColors.brightRed,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
