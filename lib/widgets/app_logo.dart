import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The Ember AI logo — a glowing red/black gradient circle with a
/// flame icon. Reused across the splash screen, sidebar header, and
/// the home "welcome" view so the brand feels consistent everywhere.
class AppLogo extends StatelessWidget {
  final double size;
  final double glowStrength;

  const AppLogo({super.key, this.size = 90, this.glowStrength = 0.6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.logoGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.brightRed.withOpacity(glowStrength),
            blurRadius: size * 0.4,
            spreadRadius: size * 0.03,
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.4), width: 1.5),
      ),
      child: Icon(
        Icons.local_fire_department_rounded,
        color: Colors.white,
        size: size * 0.52,
      ),
    );
  }
}
