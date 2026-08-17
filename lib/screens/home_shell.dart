import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_session.dart';
import '../services/storage_service.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/sidebar_drawer.dart';
import 'chat_screen.dart';
import 'welcome_view.dart';

/// The main app shell after the splash screen. Holds the Scaffold,
/// the sidebar Drawer, and switches its body between the Home
/// (welcome) view and an active ChatScreen. Also owns the list of
/// chat sessions and persists them via [ChatStorageService].
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ChatStorageService _storage = ChatStorageService();
  final _uuid = const Uuid();

  List<ChatSession> _sessions = [];
  ChatSession? _activeSession;
  bool _showHome = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await _storage.loadSessions();
    setState(() {
      _sessions = sessions;
      _loaded = true;
    });
  }

  void _persist() {
    _storage.saveSessions(_sessions);
  }

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _goHome() {
    Navigator.of(context).maybePop(); // closes drawer if open
    setState(() {
      _showHome = true;
      _activeSession = null;
    });
  }

  void _startNewChat() {
    Navigator.of(context).maybePop();
    final session = ChatSession(
      id: _uuid.v4(),
      title: "New chat",
      messages: [],
    );
    setState(() {
      _sessions.insert(0, session);
      _activeSession = session;
      _showHome = false;
    });
    _persist();
  }

  void _openSession(ChatSession session) {
    Navigator.of(context).maybePop();
    setState(() {
      _activeSession = session;
      _showHome = false;
    });
  }

  void _deleteSession(ChatSession session) {
    setState(() {
      _sessions.removeWhere((s) => s.id == session.id);
      if (_activeSession?.id == session.id) {
        _activeSession = null;
        _showHome = true;
      }
    });
    _persist();
  }

  void _onSessionChanged() {
    // Move the active session to the top of the recent list and persist.
    if (_activeSession == null) return;
    setState(() {
      _sessions.removeWhere((s) => s.id == _activeSession!.id);
      _sessions.insert(0, _activeSession!);
    });
    _persist();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final title = _showHome
        ? "Ember AI"
        : (_activeSession?.title ?? "New chat");

    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarDrawer(
        sessions: _sessions,
        activeSessionId: _activeSession?.id,
        onHomeTap: _goHome,
        onNewChatTap: _startNewChat,
        onSessionTap: _openSession,
        onDeleteTap: _deleteSession,
      ),
      appBar: ChatAppBar(
        title: title,
        onMenuTap: _openDrawer,
        onNewChat: _startNewChat,
      ),
      body: _showHome || _activeSession == null
          ? WelcomeView(onStartChat: _startNewChat)
          : ChatScreen(
              key: ValueKey(_activeSession!.id),
              session: _activeSession!,
              onSessionChanged: _onSessionChanged,
            ),
    );
  }
}
