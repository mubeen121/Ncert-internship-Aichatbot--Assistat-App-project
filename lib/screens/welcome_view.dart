import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

/// The "Home" landing view — shown when the user taps Home in the
/// sidebar or first opens the app shell (before starting a chat).
/// Displays the medium-sized logo and a warm welcome message.
class WelcomeView extends StatelessWidget {
  final VoidCallback onStartChat;

  const WelcomeView({super.key, required this.onStartChat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: 110, glowStrength: 0.5),
              const SizedBox(height: 28),
              const Text(
                "Welcome to Ember AI 🔥",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "I'm your personal assistant — ask me questions, brainstorm "
                "ideas, or just talk things through. Type, or tap the mic "
                "and speak, and let's get the conversation going.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.mutedGrey,
                  fontSize: 14.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onStartChat,
                icon: const Icon(Icons.add_comment_outlined, size: 19),
                label: const Text("Start a new chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.brightRed.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
