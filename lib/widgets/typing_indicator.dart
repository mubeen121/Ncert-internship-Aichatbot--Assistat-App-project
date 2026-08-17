import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Small "AI is typing..." bubble with three animated bouncing dots.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true, period: const Duration(milliseconds: 600));
    });

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.charcoal,
              child: Icon(Icons.local_fire_department_rounded,
                  size: 16, color: AppColors.brightRed),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: AppColors.botBubbleGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return AnimatedBuilder(
                    animation: _controllers[i],
                    builder: (context, child) {
                      final offsetY = -6 * _controllers[i].value;
                      return Transform.translate(
                        offset: Offset(0, offsetY),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.brightRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
