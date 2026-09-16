import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double rotation;
  double vRotation;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotation,
    required this.vRotation,
  });
}

class AliCelebrationOverlay extends StatefulWidget {
  final VoidCallback? onFinished;

  const AliCelebrationOverlay({super.key, this.onFinished});

  @override
  State<AliCelebrationOverlay> createState() => _AliCelebrationOverlayState();
}

class _AliCelebrationOverlayState extends State<AliCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  final List<Color> _colors = const [
    Color(0xFFFFD700), // Gold
    Color(0xFFFF6584), // Coral / Pink
    Color(0xFF8B5CF6), // Purple
    Color(0xFF10B981), // Green
    Color(0xFF3B82F6), // Blue
    Color(0xFFFBBF24), // Yellow
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..addListener(_updateParticles);

    _initParticles();
    _controller.forward().then((_) {
      widget.onFinished?.call();
    });
  }

  void _initParticles() {
    for (int i = 0; i < 70; i++) {
      _particles.add(
        ConfettiParticle(
          x: 0.5,
          y: 0.35,
          vx: (_random.nextDouble() - 0.5) * 1.8,
          vy: -_random.nextDouble() * 2.0 - 0.6,
          size: _random.nextDouble() * 10 + 6,
          color: _colors[_random.nextInt(_colors.length)],
          rotation: _random.nextDouble() * 2 * pi,
          vRotation: (_random.nextDouble() - 0.5) * 0.3,
        ),
      );
    }
  }

  void _updateParticles() {
    setState(() {
      for (final p in _particles) {
        p.x += p.vx * 0.016;
        p.y += p.vy * 0.016;
        p.vy += 0.05; // gravity
        p.rotation += p.vRotation;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _ConfettiPainter(_particles, _controller.value),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final px = p.x * size.width;
      final py = p.y * size.height;

      paint.color = p.color.withOpacity(opacity);

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
