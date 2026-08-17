import 'package:flutter/material.dart';
import '../models/chat_session.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../services/voice_service.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/typing_indicator.dart';

/// Displays one ongoing conversation. Receives a [ChatSession] to
/// read/append messages to, and calls [onSessionChanged] whenever the
/// session's messages or title are updated, so the parent (HomeShell)
/// can persist it and refresh the sidebar list.
class ChatScreen extends StatefulWidget {
  final ChatSession session;
  final VoidCallback onSessionChanged;

  const ChatScreen({
    super.key,
    required this.session,
    required this.onSessionChanged,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final VoiceService _voiceService = VoiceService();

  bool _isLoading = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    if (widget.session.messages.isEmpty) {
      widget.session.messages.add(
        Message(
          text:
              "Hello! I'm Ember AI. Ask me anything — homework help, quick "
              "facts, or just a chat. How can I help you today?",
          isUser: false,
        ),
      );
      // Don't call onSessionChanged() synchronously here: ChatScreen is
      // being built as a *child* of HomeShell's build (HomeShell -> body:
      // ChatScreen(...)), so calling widget.onSessionChanged() (which does
      // setState() on HomeShell) right now happens *during* HomeShell's
      // own build phase, which throws "setState() or markNeedsBuild()
      // called during build." Scheduling it for right after this frame
      // finishes building lets it run safely.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onSessionChanged();
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<Map<String, String>> _buildHistory() {
    final msgs = widget.session.messages;
    final recent = msgs.length > 10 ? msgs.sublist(msgs.length - 10) : msgs;
    return recent
        .where((m) => !m.isError)
        .map((m) => {
              "role": m.isUser ? "user" : "assistant",
              "content": m.text,
            })
        .toList();
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
    }

    final history = _buildHistory();
    final isFirstMessage = widget.session.messages
        .where((m) => m.isUser)
        .isEmpty;

    setState(() {
      widget.session.messages.add(Message(text: text, isUser: true));
      if (isFirstMessage) {
        widget.session.title = ChatSession.titleFromText(text);
      }
      _isLoading = true;
    });
    _textController.clear();
    widget.onSessionChanged();
    _scrollToBottom();

    try {
      final reply = await _chatService.sendToAI(text, history);
      setState(() {
        widget.session.messages.add(Message(text: reply, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        widget.session.messages.add(
          Message(
            text: e.toString().replaceFirst("Exception: ", ""),
            isUser: false,
            isError: true,
          ),
        );
        _isLoading = false;
      });
    }
    widget.onSessionChanged();
    _scrollToBottom();
  }

  Future<void> _handleMicTap() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
      return;
    }

    try {
      setState(() => _isListening = true);
      await _voiceService.startListening(
        onResult: (text) {
          _textController.text = text;
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textController.text.length),
          );
        },
      );
    } catch (e) {
      setState(() => _isListening = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst("Exception: ", "")),
            backgroundColor: AppColors.deepRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 14),
              itemCount: widget.session.messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.session.messages.length) {
                  return const TypingIndicator();
                }
                return ChatBubble(message: widget.session.messages[index]);
              },
            ),
          ),
          MessageInput(
            controller: _textController,
            onSend: _handleSend,
            isLoading: _isLoading,
            isListening: _isListening,
            onMicTap: _handleMicTap,
          ),
        ],
      ),
    );
  }
}
