import 'dart:math' as math;
import 'package:flutter/material.dart';

class WateringCan3DVector extends StatelessWidget {
  final double size;
  final double tiltAngle; // in radians, negative tilts spout downward to the left
  final bool isPouring;
  final double pourProgress; // 0.0 to 1.0 for dynamic stream and water drops

  const WateringCan3DVector({
    super.key,
    this.size = 100,
    this.tiltAngle = 0.0,
    this.isPouring = false,
    this.pourProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.3,
      height: size * 1.3,
      child: CustomPaint(
        painter: _WateringCan3DPainter(
          tiltAngle: tiltAngle,
          isPouring: isPouring,
          pourProgress: pourProgress,
        ),
      ),
    );
  }
}

class _WateringCan3DPainter extends CustomPainter {
  final double tiltAngle;
  final bool isPouring;
  final double pourProgress;

  _WateringCan3DPainter({
    required this.tiltAngle,
    required this.isPouring,
    required this.pourProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.52, size.height * 0.48);

    canvas.save();
    // Rotate around center for realistic pouring tilt
    canvas.translate(center.dx, center.dy);
    canvas.rotate(tiltAngle);
    canvas.translate(-center.dx, -center.dy);

    // 1. Soft 3D Drop Shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFF0369A1).withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 38), width: 72, height: 18),
      shadowPaint,
    );

    // 2. Arching Back Handle
    _drawHandle(canvas, center);

    // 3. Spout Pipe extending out to the left
    _drawSpout(canvas, center);

    // 4. Main Can Cylindrical / Bell Body
    _drawBody(canvas, center);

    // 5. Rose / Shower Head at end of Spout
    _drawRoseHead(canvas, center);

    // 6. Top Opening Rim & Water Level inside Can
    _drawTopRim(canvas, center);

    canvas.restore();

    // 7. Water Cascade & Droplets when pouring
    if (isPouring) {
      _drawWaterPourStream(canvas, center);
    }
  }

  void _drawHandle(Canvas canvas, Offset center) {
    // Elegant ergonomic handle from top rim to lower rear
    final handlePath = Path()
      ..moveTo(center.dx + 12, center.dy - 26)
      ..cubicTo(
        center.dx + 48, center.dy - 32, // top curve
        center.dx + 52, center.dy + 18, // outer belly
        center.dx + 26, center.dy + 24, // bottom attach
      );

    // Handle thickness under shadow
    final handleUnderPaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..strokeWidth = 9.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(handlePath, handleUnderPaint);

    // Handle gloss gradient
    final handlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF38BDF8), Color(0xFF0284C7), Color(0xFF0369A1)],
      ).createShader(Rect.fromLTWH(center.dx + 10, center.dy - 35, 45, 65))
      ..strokeWidth = 7.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(handlePath, handlePaint);

    // Handle Specular Line
    final handleHighlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final hlPath = Path()
      ..moveTo(center.dx + 16, center.dy - 24)
      ..cubicTo(center.dx + 42, center.dy - 28, center.dx + 44, center.dy + 8, center.dx + 28, center.dy + 18);
    canvas.drawPath(hlPath, handleHighlight);
  }

  void _drawSpout(Canvas canvas, Offset center) {
    // Spout emerging from lower left body up to top left
    final spoutPath = Path()
      ..moveTo(center.dx - 18, center.dy + 14)
      ..lineTo(center.dx - 48, center.dy - 22)
      ..lineTo(center.dx - 42, center.dy - 26)
      ..lineTo(center.dx - 14, center.dy + 4)
      ..close();

    final spoutPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [Color(0xFF0284C7), Color(0xFF38BDF8), Color(0xFFBAE6FD)],
      ).createShader(Rect.fromLTWH(center.dx - 50, center.dy - 30, 40, 50));
    canvas.drawPath(spoutPath, spoutPaint);
  }

  void _drawRoseHead(Canvas canvas, Offset center) {
    final headCenter = center + const Offset(-46, -24);

    // Golden brass shower sprinkler (Rose)
    final headRect = Rect.fromCenter(center: headCenter, width: 22, height: 16);
    final brassPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFDE047), Color(0xFFEAB308), Color(0xFFCA8A04)],
      ).createShader(headRect);

    canvas.save();
    canvas.translate(headCenter.dx, headCenter.dy);
    canvas.rotate(-0.5); // Spout angle
    canvas.drawOval(const Rect.fromLTWH(-10, -6, 20, 12), brassPaint);

    // Shower holes on the brass head
    final holePaint = Paint()..color = const Color(0xFF854D0E);
    for (int r = -6; r <= 6; r += 4) {
      canvas.drawCircle(Offset(r.toDouble(), 0), 1.2, holePaint);
      if (r.abs() < 5) {
        canvas.drawCircle(Offset(r.toDouble(), -3), 1.0, holePaint);
        canvas.drawCircle(Offset(r.toDouble(), 3), 1.0, holePaint);
      }
    }
    canvas.restore();
  }

  void _drawBody(Canvas canvas, Offset center) {
    final bodyRect = Rect.fromCenter(center: center, width: 62, height: 60);

    // Rounded Pot Belly Body
    final bodyPath = Path()
      ..moveTo(center.dx - 26, center.dy - 18)
      ..cubicTo(
        center.dx - 36, center.dy + 6,  // belly left
        center.dx - 28, center.dy + 28, // bottom corner left
        center.dx - 12, center.dy + 30, // bottom base
      )
      ..lineTo(center.dx + 14, center.dy + 30)
      ..cubicTo(
        center.dx + 30, center.dy + 28, // bottom corner right
        center.dx + 34, center.dy + 6,  // belly right
        center.dx + 26, center.dy - 18, // top corner right
      )
      ..close();

    // 3D Metallic Gloss Blue Body
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF0284C7), // Shadowed left
          Color(0xFF38BDF8), // Mid tone
          Color(0xFFE0F2FE), // Sharp specular shine
          Color(0xFF38BDF8), // Main cyan
          Color(0xFF0369A1), // Deep shadow right
        ],
        stops: [0.0, 0.28, 0.46, 0.72, 1.0],
      ).createShader(bodyRect);
    canvas.drawPath(bodyPath, bodyPaint);

    // Ceramic bottom rim
    final baseRect = Rect.fromCenter(center: center + const Offset(0, 30), width: 44, height: 10);
    final basePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0369A1), Color(0xFF0284C7), Color(0xFF0369A1)],
      ).createShader(baseRect);
    canvas.drawOval(baseRect, basePaint);

    // Cute Smile Decal on Can (Friendly sensory aesthetic for Ali)
    final smilePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(center.dx - 6, center.dy + 6)
      ..quadraticBezierTo(center.dx, center.dy + 12, center.dx + 6, center.dy + 6);
    canvas.drawPath(smilePath, smilePaint);

    // Cute Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFB7185).withValues(alpha: 0.6);
    canvas.drawCircle(center + const Offset(-9, 4), 3.2, cheekPaint);
    canvas.drawCircle(center + const Offset(9, 4), 3.2, cheekPaint);

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF0C4A6E);
    canvas.drawCircle(center + const Offset(-6, -1), 2.0, eyePaint);
    canvas.drawCircle(center + const Offset(6, -1), 2.0, eyePaint);
    // Eye shine
    canvas.drawCircle(center + const Offset(-6.6, -1.8), 0.8, Paint()..color = Colors.white);
    canvas.drawCircle(center + const Offset(5.4, -1.8), 0.8, Paint()..color = Colors.white);
  }

  void _drawTopRim(Canvas canvas, Offset center) {
    final rimRect = Rect.fromCenter(center: center - const Offset(0, 18), width: 52, height: 16);

    // Inner water surface inside opening
    final waterInPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF7DD3FC), Color(0xFF0284C7)],
      ).createShader(rimRect);
    canvas.drawOval(rimRect, waterInPaint);

    // Rim border
    final rimBorderPaint = Paint()
      ..color = const Color(0xFFBAE6FD)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawOval(rimRect, rimBorderPaint);

    // Rim highlight
    final rimHl = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rimRect, math.pi * 0.9, math.pi * 0.5, false, rimHl);
  }

  void _drawWaterPourStream(Canvas canvas, Offset center) {
    // Spout nozzle tip in canvas coordinates (factoring rotation)
    final cosT = math.cos(tiltAngle);
    final sinT = math.sin(tiltAngle);
    final relTip = const Offset(-52, -26);
    final nozzleTip = Offset(
      center.dx + (relTip.dx * cosT - relTip.dy * sinT),
      center.dy + (relTip.dx * sinT + relTip.dy * cosT),
    );

    // Multiple arc sprays splashing out
    final streamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFE0F2FE).withValues(alpha: 0.9),
          const Color(0xFF38BDF8),
          const Color(0xFF0284C7).withValues(alpha: 0.85),
        ],
      ).createShader(Rect.fromLTWH(nozzleTip.dx - 60, nozzleTip.dy, 80, 140));

    final dropCount = 16;
    for (int i = 0; i < dropCount; i++) {
      final spread = (i - (dropCount / 2)) * 3.5;
      final cycle = ((pourProgress * 3.5) + (i * 0.18)) % 1.0;
      final streamLength = 40.0 + (cycle * 80.0);

      // Arc spray trajectory
      final currentX = nozzleTip.dx - 10.0 + spread - (cycle * 22.0);
      final currentY = nozzleTip.dy + streamLength;

      // Sparkling water drop
      final dropRadius = 2.2 + (cycle * 2.2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(currentX, currentY),
            width: dropRadius * 1.5,
            height: dropRadius * 3.2,
          ),
          Radius.circular(dropRadius),
        ),
        streamPaint,
      );

      // Droplet white glint
      if (i % 2 == 0) {
        canvas.drawCircle(
          Offset(currentX - 1, currentY - 2),
          1.2,
          Paint()..color = Colors.white.withValues(alpha: 0.8),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WateringCan3DPainter oldDelegate) {
    return oldDelegate.tiltAngle != tiltAngle ||
        oldDelegate.isPouring != isPouring ||
        oldDelegate.pourProgress != pourProgress;
  }
}
