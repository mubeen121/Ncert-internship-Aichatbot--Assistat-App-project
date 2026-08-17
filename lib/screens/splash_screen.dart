import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'home_shell.dart';

/// The very first screen shown when the app launches.
///
/// Shows the Ember AI logo in the center:
///  - it "blinks" (pulses light/dark) via an opacity + glow animation
///  - a thin red arc rotates around it in a circle, like a loader
/// After a short delay it navigates to the main app (HomeShell).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    // Blinking / pulsing light-dark glow behind the logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    // Rotating arc loader around the logo
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, anim, __) => const HomeShell(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 170,
                height: 170,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating dashed/arc ring loader
                    AnimatedBuilder(
                      animation: _rotateController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateController.value * 2 * math.pi,
                          child: CustomPaint(
                            size: const Size(170, 170),
                            painter: _ArcLoaderPainter(),
                          ),
                        );
                      },
                    ),
                    // Pulsing / blinking glow logo
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final t = _pulseController.value; // 0 -> 1 -> 0
                        final glow = 0.35 + (0.55 * t);
                        final scale = 0.94 + (0.08 * t);
                        return Transform.scale(
                          scale: scale,
                          child: AppLogo(size: 92, glowStrength: glow),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.softWhite, AppColors.brightRed],
                ).createShader(bounds),
                child: const Text(
                  "EMBER AI",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Igniting conversations",
                style: TextStyle(
                  color: AppColors.mutedGrey,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.brightRed),
                  backgroundColor: Colors.white.withOpacity(0.08),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints a short glowing red arc that rotates around the logo,
/// giving the classic "loading ring" effect.
class _ArcLoaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(4, 4, size.width - 8, size.height - 8);

    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(rect, 0, 2 * math.pi, false, trackPaint);

    final arcPaint = Paint()
      ..shader = const SweepGradient(
        colors: [Colors.transparent, AppColors.brightRed],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 0.65, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
