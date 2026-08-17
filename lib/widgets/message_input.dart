import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Bottom input bar: mic button (voice input) + text field + send button.
class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;
  final bool isListening;
  final VoidCallback onMicTap;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
    required this.isListening,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.richBlack,
        border: Border(
          top: BorderSide(color: Color(0xFF2A0000), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _MicButton(isListening: isListening, onTap: onMicTap),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              style: const TextStyle(color: AppColors.softWhite),
              decoration: InputDecoration(
                hintText: isListening ? "Listening..." : "Ask me anything...",
              ),
            ),
          ),
          const SizedBox(width: 10),
          _SendButton(isLoading: isLoading, onSend: onSend),
        ],
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;

  const _MicButton({required this.isListening, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isListening
              ? AppColors.crimson.withOpacity(0.25)
              : AppColors.charcoal,
          shape: BoxShape.circle,
          border: Border.all(
            color: isListening ? AppColors.brightRed : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Icon(
          isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
          color: isListening ? AppColors.brightRed : AppColors.mutedGrey,
          size: 22,
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSend;

  const _SendButton({required this.isLoading, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onSend,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: AppColors.sendButtonGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.deepRed.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}
