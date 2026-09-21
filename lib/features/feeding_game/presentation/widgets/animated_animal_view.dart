import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/feeding_models.dart';

enum AnimalAnimationState {
  idle,
  anticipating, // Food is getting close, open mouth wider!
  chewing,      // Eating happily (squash & stretch, eyes closed, stars)
  rejected,     // Wrong food (shake head, funny shocked reaction)
  spicy,        // Ate hot chili! Red face, steam/smoke out of ears, vibrating eyes & panting tongue
}

class AnimatedAnimalView extends StatefulWidget {
  final AnimalProfile animal;
  final AnimalAnimationState state;
  final Offset? dragPosition; // Position of dragging food relative to animal center
  final double hungerProgress; // 0.0 to 1.0

  const AnimatedAnimalView({
    super.key,
    required this.animal,
    required this.state,
    this.dragPosition,
    this.hungerProgress = 0.0,
  });

  @override
  State<AnimatedAnimalView> createState() => _AnimatedAnimalViewState();
}

class _AnimatedAnimalViewState extends State<AnimatedAnimalView>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _chewController;
  late AnimationController _rejectController;
  late AnimationController _spicyController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _chewController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _rejectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _spicyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedAnimalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == AnimalAnimationState.chewing &&
        oldWidget.state != AnimalAnimationState.chewing) {
      _chewController.repeat(reverse: true);
    } else if (widget.state != AnimalAnimationState.chewing) {
      _chewController.stop();
      _chewController.reset();
    }

    if (widget.state == AnimalAnimationState.rejected &&
        oldWidget.state != AnimalAnimationState.rejected) {
      _rejectController.forward(from: 0.0);
    }

    if (widget.state == AnimalAnimationState.spicy &&
        oldWidget.state != AnimalAnimationState.spicy) {
      _spicyController.forward(from: 0.0);
    } else if (widget.state != AnimalAnimationState.spicy) {
      _spicyController.stop();
      _spicyController.reset();
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _chewController.dispose();
    _rejectController.dispose();
    _spicyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _idleController,
        _chewController,
        _rejectController,
        _spicyController,
      ]),
      builder: (context, child) {
        // 1. Calculate breathing & idle subtle bounce
        final breathe = math.sin(_idleController.value * math.pi) * 6.0;

        // 2. Calculate head rotation & eye offset based on drag position
        double eyeOffsetX = 0.0;
        double eyeOffsetY = 0.0;
        double headRotate = 0.0;
        double jitterX = 0.0;
        double jitterY = 0.0;

        if (widget.dragPosition != null &&
            widget.state != AnimalAnimationState.rejected &&
            widget.state != AnimalAnimationState.spicy) {
          final dx = widget.dragPosition!.dx.clamp(-120.0, 120.0);
          final dy = widget.dragPosition!.dy.clamp(-120.0, 120.0);
          eyeOffsetX = (dx / 120.0) * 8.0;
          eyeOffsetY = (dy / 120.0) * 8.0;
          headRotate = (dx / 120.0) * 0.12; // tilt head towards food!
        }

        // 3. Rejection head shake
        if (_rejectController.isAnimating) {
          final shake = math.sin(_rejectController.value * math.pi * 6) * 16.0;
          headRotate = (shake / 60.0);
          eyeOffsetX = shake * 0.4;
        }

        // 3b. Spicy vibration jitter & panting
        if (widget.state == AnimalAnimationState.spicy) {
          final spicyPhase = _spicyController.value * math.pi * 32;
          jitterX = math.sin(spicyPhase) * 4.5;
          jitterY = math.cos(spicyPhase * 1.5) * 3.0;
          headRotate = math.sin(spicyPhase * 0.5) * 0.06;
        }

        // 4. Chew squash and stretch
        double scaleX = 1.0;
        double scaleY = 1.0;
        if (widget.state == AnimalAnimationState.chewing) {
          final chewVal = _chewController.value;
          scaleX = 1.0 + (chewVal * 0.08);
          scaleY = 1.0 - (chewVal * 0.08);
        } else if (widget.state == AnimalAnimationState.spicy) {
          // Panting rapid squish
          final pant = math.sin(_spicyController.value * math.pi * 16) * 0.05;
          scaleX = 1.0 + pant;
          scaleY = 1.0 - pant;
        }

        return Transform.translate(
          offset: Offset(jitterX, breathe + jitterY),
          child: Transform.rotate(
            angle: headRotate,
            child: Transform.scale(
              scaleX: scaleX,
              scaleY: scaleY,
              child: SizedBox(
                width: 290,
                height: 290,
                child: CustomPaint(
                  painter: _Animal3DVectorPainter(
                    animal: widget.animal,
                    animalType: widget.animal.type,
                    state: widget.state,
                    eyeOffsetX: eyeOffsetX,
                    eyeOffsetY: eyeOffsetY,
                    headRotate: headRotate,
                    dragDistance: widget.dragPosition?.distance,
                    chewProgress: _chewController.value,
                    rejectProgress: _rejectController.value,
                    spicyProgress: _spicyController.value,
                    breatheProgress: _idleController.value,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Animal3DVectorPainter extends CustomPainter {
  final AnimalProfile animal;
  final AnimalType animalType;
  final AnimalAnimationState state;
  final double eyeOffsetX;
  final double eyeOffsetY;
  final double headRotate;
  final double? dragDistance;
  final double chewProgress;
  final double rejectProgress;
  final double spicyProgress;
  final double breatheProgress;

  _Animal3DVectorPainter({
    required this.animal,
    required this.animalType,
    required this.state,
    required this.eyeOffsetX,
    required this.eyeOffsetY,
    required this.headRotate,
    this.dragDistance,
    required this.chewProgress,
    required this.rejectProgress,
    required this.spicyProgress,
    required this.breatheProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (animalType) {
      case AnimalType.cat:
        _paint3DCat(canvas, center, size);
        break;
      case AnimalType.chicken:
        _paintChicken(canvas, center, size);
        break;
      case AnimalType.panda:
        _paintPanda(canvas, center, size);
        break;
      case AnimalType.rabbit:
        _paintRabbit(canvas, center, size);
        break;
      case AnimalType.fish:
        _paintFish(canvas, center, size);
        break;
      case AnimalType.lion:
        _paint3DLion(canvas, center, size);
        break;
      case AnimalType.tiger:
        _paint3DTiger(canvas, center, size);
        break;
      case AnimalType.duck:
        _paint3DDuck(canvas, center, size);
        break;
      case AnimalType.cow:
        _paint3DCow(canvas, center, size);
        break;
      case AnimalType.monkey:
        _paint3DMonkey(canvas, center, size);
        break;
      case AnimalType.sheep:
        _paint3DSheep(canvas, center, size);
        break;
      case AnimalType.owl:
        _paint3DOwl(canvas, center, size);
        break;
      case AnimalType.bird:
        _paint3DBird(canvas, center, size);
        break;
      case AnimalType.horse:
        _paint3DHorse(canvas, center, size);
        break;
      case AnimalType.dog:
        _paint3DDog(canvas, center, size);
        break;
      case AnimalType.koala:
        _paint3DKoala(canvas, center, size);
        break;
      case AnimalType.penguin:
        _paint3DPenguin(canvas, center, size);
        break;
      case AnimalType.squirrel:
        _paint3DSquirrel(canvas, center, size);
        break;
      case AnimalType.giraffe:
        _paint3DGiraffe(canvas, center, size);
        break;
      case AnimalType.elephant:
        _paint3DElephant(canvas, center, size);
        break;
      case AnimalType.frog:
        _paint3DFrog(canvas, center, size);
        break;
      case AnimalType.dolphin:
        _paint3DDolphin(canvas, center, size);
        break;
    }

    // Overlay spicy steam & fiery overheated glow across all animals
    if (state == AnimalAnimationState.spicy) {
      _drawSpicyEffects(canvas, center, size);
    }
  }

  // =========================================================================
  // 1. KUCING 3D VECTOR (CLAY/PIXAR STYLE WITH DYNAMIC MOUTH & REAL-TIME GAZE)
  // =========================================================================
  void _paint3DCat(Canvas canvas, Offset center, Size size) {
    // A. 3D Ambient Floor Occlusion Shadow
    final shadowPath = Path()
      ..addOval(Rect.fromCenter(
        center: center + const Offset(0, 110),
        width: 200,
        height: 32,
      ));
    canvas.drawShadow(shadowPath, Colors.black, 16, false);
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 190, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.22),
    );

    // B. 3D Ears with Depth & Inner Velvet
    _draw3DCatEars(canvas, center);

    // C. 3D Spherical Head with Studio Lighting Gradients
    _draw3DCatHead(canvas, center);

    // D. 3D Grey/Silver Fur Accent Patches
    _draw3DCatFurPatches(canvas, center);

    // E. 3D Expressive Glossy Eyes (Specular Balls tracking food)
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-42, -18),
      rightPos: center + const Offset(42, -18),
      radius: 18,
    );

    // F. Cute 3D Pink Button Nose
    _draw3DNose(canvas, center + const Offset(0, 16));

    // G. 3D Interactive Mouth & Jaw (Mangap dinamis sesuai jarak makanan!)
    _draw3DInteractiveMouth(canvas, center + const Offset(0, 42));

    // H. 3D Whiskers
    _draw3DWhiskers(canvas, center);

    // I. Chewing celebratory stars
    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  void _draw3DCatEars(Canvas canvas, Offset center) {
    // Left Ear 3D Outer
    final leftEarPath = Path()
      ..moveTo(center.dx - 80, center.dy - 35)
      ..cubicTo(center.dx - 105, center.dy - 75, center.dx - 95, center.dy - 120, center.dx - 82, center.dy - 128)
      ..cubicTo(center.dx - 65, center.dy - 110, center.dx - 35, center.dy - 85, center.dx - 28, center.dy - 68)
      ..close();

    final leftEarPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF94A3B8), Color(0xFF475569), Color(0xFF334155)],
      ).createShader(Rect.fromLTWH(center.dx - 105, center.dy - 128, 80, 100));
    canvas.drawPath(leftEarPath, leftEarPaint);

    // Left Ear Inner Pink Velvet
    final leftEarInner = Path()
      ..moveTo(center.dx - 75, center.dy - 42)
      ..cubicTo(center.dx - 92, center.dy - 75, center.dx - 86, center.dy - 110, center.dx - 78, center.dy - 116)
      ..cubicTo(center.dx - 62, center.dy - 98, center.dx - 40, center.dy - 80, center.dx - 36, center.dy - 68)
      ..close();

    final leftInnerPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.2),
        colors: [Color(0xFFFDE8E8), Color(0xFFF472B6), Color(0xFFBE185D)],
      ).createShader(Rect.fromLTWH(center.dx - 92, center.dy - 116, 60, 80));
    canvas.drawPath(leftEarInner, leftInnerPaint);

    // Right Ear 3D Outer
    final rightEarPath = Path()
      ..moveTo(center.dx + 80, center.dy - 35)
      ..cubicTo(center.dx + 105, center.dy - 75, center.dx + 95, center.dy - 120, center.dx + 82, center.dy - 128)
      ..cubicTo(center.dx + 65, center.dy - 110, center.dx + 35, center.dy - 85, center.dx + 28, center.dy - 68)
      ..close();

    final rightEarPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF94A3B8), Color(0xFF475569), Color(0xFF334155)],
      ).createShader(Rect.fromLTWH(center.dx + 28, center.dy - 128, 80, 100));
    canvas.drawPath(rightEarPath, rightEarPaint);

    // Right Ear Inner Pink Velvet
    final rightEarInner = Path()
      ..moveTo(center.dx + 75, center.dy - 42)
      ..cubicTo(center.dx + 92, center.dy - 75, center.dx + 86, center.dy - 110, center.dx + 78, center.dy - 116)
      ..cubicTo(center.dx + 62, center.dy - 98, center.dx + 40, center.dy - 80, center.dx + 36, center.dy - 68)
      ..close();

    final rightInnerPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.2, -0.2),
        colors: [Color(0xFFFDE8E8), Color(0xFFF472B6), Color(0xFFBE185D)],
      ).createShader(Rect.fromLTWH(center.dx + 32, center.dy - 116, 60, 80));
    canvas.drawPath(rightEarInner, rightInnerPaint);
  }

  void _draw3DCatHead(Canvas canvas, Offset center) {
    // Spherical Clay/Pixar Head Base
    final headRect = Rect.fromCenter(center: center, width: 200, height: 185);

    // 1. Ambient Rim Shadow (Subtle dark under-glow)
    final rimShadowPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.0, 0.4),
        radius: 0.95,
        colors: [Colors.transparent, Color(0x33334155)],
      ).createShader(headRect);
    canvas.drawOval(headRect.inflate(2), rimShadowPaint);

    // 2. 3D Body Surface: Warm Soft Cream-White with Multi-stop Radial Shader
    final headBasePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.28, -0.38),
        radius: 0.9,
        colors: [
          Color(0xFFFFFFFF), // Specular Key Light
          Color(0xFFF8FAFC),
          Color(0xFFF1F5F9),
          Color(0xFFE2E8F0),
          Color(0xFFCBD5E1), // Shadow Rim
        ],
        stops: [0.0, 0.35, 0.65, 0.88, 1.0],
      ).createShader(headRect);
    canvas.drawOval(headRect, headBasePaint);

    // 3. Specular Highlight Bulb (Top-Left 3D Glaze)
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.45),
        radius: 0.5,
        colors: [
          Colors.white.withValues(alpha: 0.65),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(headRect);
    canvas.drawOval(Rect.fromCenter(center: center + const Offset(-35, -35), width: 95, height: 75), highlightPaint);
  }

  void _draw3DCatFurPatches(Canvas canvas, Offset center) {
    // 3D Grey/Silver Patches with Volume Gradient
    final patchRect = Rect.fromCenter(center: center, width: 195, height: 180);

    // Left Patch
    final leftPatch = Path()
      ..moveTo(center.dx - 95, center.dy - 10)
      ..cubicTo(center.dx - 98, center.dy - 70, center.dx - 70, center.dy - 85, center.dx - 22, center.dy - 78)
      ..cubicTo(center.dx - 15, center.dy - 40, center.dx - 35, center.dy - 10, center.dx - 70, center.dy)
      ..close();

    final leftFurPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.4, -0.3),
        radius: 0.85,
        colors: [
          Color(0xFF94A3B8),
          Color(0xFF64748B),
          Color(0xFF475569),
          Color(0xFF334155),
        ],
      ).createShader(patchRect);
    canvas.drawPath(leftPatch, leftFurPaint);

    // Right Patch
    final rightPatch = Path()
      ..moveTo(center.dx + 95, center.dy - 10)
      ..cubicTo(center.dx + 98, center.dy - 70, center.dx + 70, center.dy - 85, center.dx + 22, center.dy - 78)
      ..cubicTo(center.dx + 15, center.dy - 40, center.dx + 35, center.dy - 10, center.dx + 70, center.dy)
      ..close();

    final rightFurPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.4, -0.3),
        radius: 0.85,
        colors: [
          Color(0xFF94A3B8),
          Color(0xFF64748B),
          Color(0xFF475569),
          Color(0xFF334155),
        ],
      ).createShader(patchRect);
    canvas.drawPath(rightPatch, rightFurPaint);

    // 3D Soft Cheeks (Muzzle Puff)
    final muzzleRect = Rect.fromCenter(center: center + const Offset(0, 30), width: 115, height: 62);
    final muzzlePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.0, -0.2),
        radius: 0.8,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF8FAFC),
          Color(0xFFF1F5F9),
        ],
      ).createShader(muzzleRect);
    canvas.drawRRect(RRect.fromRectAndRadius(muzzleRect, const Radius.circular(30)), muzzlePaint);

    // Rosy Airbrushed 3D Blush
    final blushPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDA4AF).withValues(alpha: 0.6),
          const Color(0xFFFDA4AF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center + const Offset(-58, 26), radius: 18));
    canvas.drawCircle(center + const Offset(-58, 26), 18, blushPaint);

    final blushPaintR = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDA4AF).withValues(alpha: 0.6),
          const Color(0xFFFDA4AF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center + const Offset(58, 26), radius: 18));
    canvas.drawCircle(center + const Offset(58, 26), 18, blushPaintR);
  }

  void _draw3DGlossyEyes(
    Canvas canvas, {
    required Offset leftPos,
    required Offset rightPos,
    required double radius,
  }) {
    void drawSingleEye(Offset eyeCenter, bool isLeft) {
      if (state == AnimalAnimationState.chewing) {
        // Happy Curved Arc Eyes (^_^) with 3D Depth
        final eyeArcPaint = Paint()
          ..color = const Color(0xFF1E293B)
          ..strokeWidth = 4.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCenter(center: eyeCenter + const Offset(0, 2), width: radius * 2.2, height: radius * 1.6),
          math.pi,
          math.pi,
          false,
          eyeArcPaint,
        );
        return;
      }

      if (state == AnimalAnimationState.rejected) {
        // Shocked / Dizzy 3D Eyes
        canvas.drawCircle(eyeCenter, radius * 1.25, Paint()..color = Colors.white);
        canvas.drawCircle(
          eyeCenter,
          radius * 1.25,
          Paint()
            ..color = const Color(0xFFCBD5E1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        // Swirl / Cross Pupil
        final spiralPaint = Paint()
          ..color = const Color(0xFFEF4444)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(eyeCenter - const Offset(6, 6), eyeCenter + const Offset(6, 6), spiralPaint);
        canvas.drawLine(eyeCenter - const Offset(-6, 6), eyeCenter + const Offset(-6, 6), spiralPaint);
        return;
      }

      if (state == AnimalAnimationState.spicy) {
        // Bulging Wide Bloodshot Eyes with Tiny Panicked Pupils
        final spicyRadius = radius * 1.35;
        // White sclera with reddish rim
        canvas.drawCircle(
          eyeCenter,
          spicyRadius,
          Paint()
            ..shader = RadialGradient(
              colors: [
                Colors.white,
                const Color(0xFFFEE2E2),
                const Color(0xFFEF4444).withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.7, 1.0],
            ).createShader(Rect.fromCircle(center: eyeCenter, radius: spicyRadius)),
        );

        // Vein / red lines
        final veinPaint = Paint()
          ..color = const Color(0xFFDC2626).withValues(alpha: 0.7)
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(eyeCenter + Offset(-spicyRadius * 0.7, -spicyRadius * 0.3), eyeCenter + Offset(-spicyRadius * 0.2, 0), veinPaint);
        canvas.drawLine(eyeCenter + Offset(spicyRadius * 0.7, -spicyRadius * 0.3), eyeCenter + Offset(spicyRadius * 0.2, 0), veinPaint);
        canvas.drawLine(eyeCenter + Offset(0, -spicyRadius * 0.7), eyeCenter + Offset(0, -spicyRadius * 0.2), veinPaint);

        // Tiny vibrating pupil
        final pupilJitter = math.sin(spicyProgress * math.pi * 30) * 3.0;
        final pupilCenter = eyeCenter + Offset(pupilJitter, 0);
        canvas.drawCircle(pupilCenter, 5, Paint()..color = const Color(0xFF991B1B));
        canvas.drawCircle(pupilCenter, 3, Paint()..color = Colors.black);
        canvas.drawCircle(pupilCenter - const Offset(1.5, 1.5), 1.5, Paint()..color = Colors.white);
        return;
      }

      // 1. Eye Socket Shadow Depth
      canvas.drawCircle(
        eyeCenter + const Offset(0, 1.5),
        radius + 1.5,
        Paint()..color = const Color(0xFF94A3B8).withValues(alpha: 0.45),
      );

      // 2. Sclera (White Ball with 3D Spherical Light)
      final eyeRect = Rect.fromCircle(center: eyeCenter, radius: radius);
      final scleraPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.2, -0.3),
          radius: 0.8,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF8FAFC),
            Color(0xFFE2E8F0),
          ],
        ).createShader(eyeRect);
      canvas.drawCircle(eyeCenter, radius, scleraPaint);

      // 3. Dynamic Pupil Position (Real-time Gaze Following Food!)
      final pupilTarget = eyeCenter + Offset(eyeOffsetX * 1.3, eyeOffsetY * 1.3);
      final pupilRadius = radius * 0.65;

      // Iris (Emerald Green/Aqua 3D Gradient like cute kitten)
      final irisRect = Rect.fromCircle(center: pupilTarget, radius: pupilRadius);
      final irisPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.25, -0.3),
          colors: [
            Color(0xFF10B981), // Emerald bright
            Color(0xFF047857), // Forest green
            Color(0xFF064E3B), // Deep rim
          ],
        ).createShader(irisRect);
      canvas.drawCircle(pupilTarget, pupilRadius, irisPaint);

      // Deep Black Center Core
      canvas.drawCircle(pupilTarget, pupilRadius * 0.55, Paint()..color = const Color(0xFF0F172A));

      // 4. Glossy Specular Reflections (Glass/Marble 3D effect)
      // Primary Specular
      canvas.drawCircle(
        pupilTarget + const Offset(-3.5, -4.0),
        pupilRadius * 0.32,
        Paint()..color = Colors.white,
      );
      // Secondary Soft Reflection
      canvas.drawCircle(
        pupilTarget + const Offset(3.5, 3.5),
        pupilRadius * 0.16,
        Paint()..color = Colors.white.withValues(alpha: 0.85),
      );
    }

    drawSingleEye(leftPos, true);
    drawSingleEye(rightPos, false);
  }

  void _draw3DNose(Canvas canvas, Offset noseCenter) {
    // 3D Soft Pink Button Nose with Specular Highlight
    final noseRect = Rect.fromCenter(center: noseCenter, width: 20, height: 14);
    final nosePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFB7185), // Rosy Pink
          Color(0xFFE11D48), // Deep Berry Pink
        ],
      ).createShader(noseRect);

    final noseRRect = RRect.fromRectAndRadius(noseRect, const Radius.circular(7));
    canvas.drawRRect(noseRRect, nosePaint);

    // Nose Highlight
    canvas.drawOval(
      Rect.fromCenter(center: noseCenter + const Offset(0, -2.5), width: 8, height: 3.5),
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );
  }

  void _draw3DInteractiveMouth(Canvas canvas, Offset mouthCenter) {
    // Dynamic Jaw Opening Calculation:
    // When food approaches, jaw drops progressively (0.0 to 1.0)
    double openFactor = 0.0;

    if (state == AnimalAnimationState.anticipating) {
      openFactor = 0.85;
    } else if (dragDistance != null && state != AnimalAnimationState.rejected && state != AnimalAnimationState.chewing) {
      // Proximity: distance 250px -> 0.0, distance 50px -> 1.0
      openFactor = ((250.0 - dragDistance!) / 200.0).clamp(0.0, 1.0);
    } else if (state == AnimalAnimationState.chewing) {
      openFactor = math.sin(chewProgress * math.pi) * 0.45;
    }

    if (state == AnimalAnimationState.rejected) {
      // Disgusted Squiggly mouth with sticking out tongue
      final rejectPaint = Paint()
        ..color = const Color(0xFF991B1B)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final p = Path()
        ..moveTo(mouthCenter.dx - 22, mouthCenter.dy + 8)
        ..quadraticBezierTo(mouthCenter.dx - 10, mouthCenter.dy - 6, mouthCenter.dx, mouthCenter.dy + 4)
        ..quadraticBezierTo(mouthCenter.dx + 10, mouthCenter.dy + 14, mouthCenter.dx + 22, mouthCenter.dy + 2);
      canvas.drawPath(p, rejectPaint);

      // Drooping Tongue
      final tonguePath = Path()
        ..moveTo(mouthCenter.dx - 6, mouthCenter.dy + 4)
        ..cubicTo(mouthCenter.dx - 8, mouthCenter.dy + 22, mouthCenter.dx + 8, mouthCenter.dy + 22, mouthCenter.dx + 6, mouthCenter.dy + 4)
        ..close();
      canvas.drawPath(tonguePath, Paint()..color = const Color(0xFFFB7185));
      return;
    }

    if (state == AnimalAnimationState.spicy) {
      // Mouth Wide Open Panting with Long Hot Sticking Out Tongue! (Hahh Hahh!)
      final pantDrop = math.sin(spicyProgress * math.pi * 18).abs() * 6.0;
      final spicyMouthRect = Rect.fromCenter(
        center: mouthCenter + Offset(0, 8),
        width: 54,
        height: 44 + pantDrop,
      );

      // Dark Burning Oral Cavity
      final cavityPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -0.2),
          radius: 0.8,
          colors: [
            Color(0xFF991B1B), // Red fire throat
            Color(0xFF4C0519),
            Color(0xFF1E030B),
          ],
        ).createShader(spicyMouthRect);
      canvas.drawRRect(RRect.fromRectAndRadius(spicyMouthRect, const Radius.circular(22)), cavityPaint);

      // Hot Panting Tongue Hanging Far Down
      final tongueH = 34.0 + pantDrop;
      final tongueRect = Rect.fromCenter(
        center: mouthCenter + Offset(0, 18 + pantDrop * 0.8),
        width: 24,
        height: tongueH,
      );
      final tonguePaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFDA4AF),
            Color(0xFFF43F5E),
            Color(0xFFE11D48),
          ],
        ).createShader(tongueRect);
      canvas.drawRRect(RRect.fromRectAndRadius(tongueRect, const Radius.circular(12)), tonguePaint);

      // Tongue Mid-line Crease
      canvas.drawLine(
        mouthCenter + const Offset(0, 10),
        mouthCenter + Offset(0, 16 + tongueH * 0.4),
        Paint()
          ..color = const Color(0xFF9F1239).withValues(alpha: 0.6)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      // Little cute sharp teeth visible when panting
      final toothP = Paint()..color = Colors.white;
      canvas.drawCircle(mouthCenter + const Offset(-14, 0), 3, toothP);
      canvas.drawCircle(mouthCenter + const Offset(14, 0), 3, toothP);
      return;
    }

    if (openFactor > 0.08) {
      // ==========================================
      // MOUTH WIDE OPEN (Mangap 3D Real-time!)
      // ==========================================
      final mouthWidth = 42.0 + (openFactor * 22.0);
      final mouthHeight = 16.0 + (openFactor * 42.0);
      final mouthRect = Rect.fromCenter(
        center: mouthCenter + Offset(0, openFactor * 8.0),
        width: mouthWidth,
        height: mouthHeight,
      );

      // Deep Oral Cavity (Dark Maroon with 3D Depth shading)
      final mouthCavityPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -0.2),
          radius: 0.75,
          colors: [
            Color(0xFF881337), // Rosewood
            Color(0xFF4C0519), // Deep Wine
            Color(0xFF1E030B), // Throat depth
          ],
        ).createShader(mouthRect);

      final mouthRRect = RRect.fromRectAndRadius(mouthRect, Radius.circular(mouthHeight * 0.48));
      canvas.drawRRect(mouthRRect, mouthCavityPaint);

      // Cavity Inner Border Stroke
      canvas.drawRRect(
        mouthRRect,
        Paint()
          ..color = const Color(0xFFFDA4AF).withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      // 3D Rounded Tongue inside mouth
      final tongueY = mouthRect.bottom - (mouthHeight * 0.35);
      final tongueRect = Rect.fromCenter(
        center: Offset(mouthCenter.dx, tongueY),
        width: mouthWidth * 0.65,
        height: mouthHeight * 0.45,
      );
      final tonguePaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFDA4AF), // Soft Pink
            Color(0xFFF43F5E), // Vivid Rose
          ],
        ).createShader(tongueRect);
      canvas.drawOval(tongueRect, tonguePaint);

      // Tiny Cute 3D Kitten Teeth (Top)
      final toothPaint = Paint()..color = Colors.white;
      // Left canine
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: mouthCenter + Offset(-mouthWidth * 0.28, -mouthHeight * 0.32 + (openFactor * 8)), width: 5, height: 8),
          const Radius.circular(2),
        ),
        toothPaint,
      );
      // Right canine
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: mouthCenter + Offset(mouthWidth * 0.28, -mouthHeight * 0.32 + (openFactor * 8)), width: 5, height: 8),
          const Radius.circular(2),
        ),
        toothPaint,
      );
    } else {
      // ==========================================
      // IDLE CUTE 3D CAT SMILE (:3 Cat Mouth Shape)
      // ==========================================
      final smilePaint = Paint()
        ..color = const Color(0xFF475569)
        ..strokeWidth = 3.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Left curl (:3)
      final leftCurl = Path()
        ..moveTo(mouthCenter.dx, mouthCenter.dy - 6)
        ..lineTo(mouthCenter.dx, mouthCenter.dy)
        ..cubicTo(mouthCenter.dx, mouthCenter.dy + 12, mouthCenter.dx - 18, mouthCenter.dy + 12, mouthCenter.dx - 18, mouthCenter.dy + 3);
      canvas.drawPath(leftCurl, smilePaint);

      // Right curl (:3)
      final rightCurl = Path()
        ..moveTo(mouthCenter.dx, mouthCenter.dy)
        ..cubicTo(mouthCenter.dx, mouthCenter.dy + 12, mouthCenter.dx + 18, mouthCenter.dy + 12, mouthCenter.dx + 18, mouthCenter.dy + 3);
      canvas.drawPath(rightCurl, smilePaint);
    }
  }

  void _draw3DWhiskers(Canvas canvas, Offset center) {
    final whiskerPaint = Paint()
      ..color = const Color(0xFF64748B).withValues(alpha: 0.55)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Subtle whisker twitch from breathing
    final twitch = math.sin(breatheProgress * math.pi * 2) * 2.0;

    // Left Whiskers
    canvas.drawLine(center + const Offset(-44, 22), center + Offset(-84, 18 + twitch), whiskerPaint);
    canvas.drawLine(center + const Offset(-44, 32), center + Offset(-82, 36 - twitch), whiskerPaint);

    // Right Whiskers
    canvas.drawLine(center + const Offset(44, 22), center + Offset(84, 18 + twitch), whiskerPaint);
    canvas.drawLine(center + const Offset(44, 32), center + Offset(82, 36 - twitch), whiskerPaint);
  }

  void _drawChewingStars(Canvas canvas, Offset center) {
    final starPaint = Paint()..color = const Color(0xFFFBBF24);
    // Draw playful sparkling stars
    final starOffset1 = center + const Offset(78, -55);
    final starOffset2 = center + const Offset(-78, -50);
    _drawMiniStar(canvas, starOffset1, 10, starPaint);
    _drawMiniStar(canvas, starOffset2, 8, starPaint);
  }

  void _drawMiniStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final r = (i % 2 == 0) ? radius : radius * 0.45;
      final angle = (i * math.pi) / 4;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }


  // ==========================================
  // 2. AYAM JANTAN (SI JAGO)
  // ==========================================
  // ==========================================
  // 2. AYAM JANTAN (SI JAGO) 3D VECTOR
  // ==========================================
  void _paintChicken(Canvas canvas, Offset center, Size size) {
    // 3D Ambient Floor Shadow
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 105), width: 190, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.18),
    );

    // 3D Red Comb on Head (3 glossy bulbs with highlight)
    final combBulbs = [
      Offset(center.dx - 26, center.dy - 82),
      Offset(center.dx, center.dy - 96),
      Offset(center.dx + 26, center.dy - 82),
    ];
    final combRadii = [20.0, 26.0, 20.0];

    for (int i = 0; i < combBulbs.length; i++) {
      final p = combBulbs[i];
      final r = combRadii[i];
      final combPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.3),
          radius: 0.85,
          colors: const [Color(0xFFEF4444), Color(0xFFDC2626), Color(0xFF991B1B)],
        ).createShader(Rect.fromCircle(center: p, radius: r));
      canvas.drawCircle(p, r, combPaint);
      // Comb Specular Highlight
      canvas.drawCircle(
        p - Offset(r * 0.25, r * 0.3),
        r * 0.25,
        Paint()..color = Colors.white.withValues(alpha: 0.55),
      );
    }

    // 3D Spherical Head/Body (Warm Cream/Yellow Feather Clay)
    final headRect = Rect.fromCenter(center: center, width: 185, height: 175);
    final headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.28, -0.38),
        radius: 0.9,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFFEF9C3), // Pale yellow
          Color(0xFFFDE047), // Sunny yellow
          Color(0xFFEAB308), // Amber rim
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(headRect);
    canvas.drawOval(headRect, headPaint);

    // Head Specular Glaze
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(-32, -32), width: 85, height: 65),
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withValues(alpha: 0.6), Colors.white.withValues(alpha: 0.0)],
        ).createShader(headRect),
    );

    // Gelambir Bawah (3D Red Wattle below beak)
    final wattleRect = Rect.fromCenter(center: center + const Offset(0, 52), width: 26, height: 38);
    final wattlePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.2),
        colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
      ).createShader(wattleRect);
    canvas.drawRRect(RRect.fromRectAndRadius(wattleRect, const Radius.circular(13)), wattlePaint);

    // 3D Expressive Glossy Eyes
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-38, -18),
      rightPos: center + const Offset(38, -18),
      radius: 17,
    );

    // Rosy Blush
    final blushPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFB923C).withValues(alpha: 0.5), const Color(0xFFFB923C).withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: center + const Offset(-52, 22), radius: 16));
    canvas.drawCircle(center + const Offset(-52, 22), 16, blushPaint);
    canvas.drawCircle(center + const Offset(52, 22), 16, blushPaint);

    // 3D Interactive Beak (Paruh Emas 3D Mangap Dinamis!)
    _draw3DChickenBeak(canvas, center + const Offset(0, 16));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  void _draw3DChickenBeak(Canvas canvas, Offset beakCenter) {
    double openFactor = 0.0;
    if (state == AnimalAnimationState.anticipating) {
      openFactor = 0.9;
    } else if (dragDistance != null && state != AnimalAnimationState.rejected && state != AnimalAnimationState.chewing) {
      openFactor = ((250.0 - dragDistance!) / 200.0).clamp(0.0, 1.0);
    } else if (state == AnimalAnimationState.chewing) {
      openFactor = math.sin(chewProgress * math.pi) * 0.5;
    }

    final beakDrop = openFactor * 24.0;

    // Inside Beak Oral Cavity (when open)
    if (openFactor > 0.08) {
      final cavityRect = Rect.fromCenter(
        center: beakCenter + Offset(0, 4 + beakDrop * 0.5),
        width: 32,
        height: 12 + beakDrop,
      );
      canvas.drawOval(
        cavityRect,
        Paint()
          ..shader = const RadialGradient(
            colors: [Color(0xFF881337), Color(0xFF4C0519)],
          ).createShader(cavityRect),
      );
      // Small Pink Tongue
      canvas.drawOval(
        Rect.fromCenter(center: beakCenter + Offset(0, 4 + beakDrop * 0.7), width: 16, height: beakDrop * 0.5),
        Paint()..color = const Color(0xFFFB7185),
      );
    }

    // Upper 3D Golden Beak
    final upperPath = Path()
      ..moveTo(beakCenter.dx - 26, beakCenter.dy)
      ..cubicTo(beakCenter.dx - 14, beakCenter.dy - 16, beakCenter.dx + 14, beakCenter.dy - 16, beakCenter.dx + 26, beakCenter.dy)
      ..lineTo(beakCenter.dx, beakCenter.dy + 14)
      ..close();

    final upperPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFDBA74), Color(0xFFF97316), Color(0xFFC2410C)],
      ).createShader(Rect.fromLTWH(beakCenter.dx - 26, beakCenter.dy - 16, 52, 30));
    canvas.drawPath(upperPath, upperPaint);

    // Beak Top Specular Ridge
    final ridgePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(beakCenter + const Offset(0, -10), beakCenter + const Offset(0, 8), ridgePaint);

    // Lower 3D Beak (Drops dynamically!)
    final lowerPath = Path()
      ..moveTo(beakCenter.dx - 20, beakCenter.dy + 4)
      ..lineTo(beakCenter.dx, beakCenter.dy + 16 + beakDrop)
      ..lineTo(beakCenter.dx + 20, beakCenter.dy + 4)
      ..close();

    final lowerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFEA580C), Color(0xFF9A3412)],
      ).createShader(Rect.fromLTWH(beakCenter.dx - 20, beakCenter.dy + 4, 40, 20 + beakDrop));
    canvas.drawPath(lowerPath, lowerPaint);
  }

  // ==========================================
  // 3. PANDA (SI GEMBUL) 3D VECTOR
  // ==========================================
  void _paintPanda(Canvas canvas, Offset center, Size size) {
    // 3D Floor Shadow
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 210, height: 30),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.22),
    );

    // 3D Round Velvet Black Ears
    final leftEarCenter = center + const Offset(-75, -72);
    final rightEarCenter = center + const Offset(75, -72);

    for (final earC in [leftEarCenter, rightEarCenter]) {
      final earRect = Rect.fromCircle(center: earC, radius: 34);
      final earPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.25, -0.3),
          radius: 0.85,
          colors: [Color(0xFF475569), Color(0xFF1E293B), Color(0xFF0F172A)],
        ).createShader(earRect);
      canvas.drawCircle(earC, 34, earPaint);
      canvas.drawCircle(earC - const Offset(6, 6), 9, Paint()..color = Colors.white.withValues(alpha: 0.15));
    }

    // 3D Round Panda Head (Chubby Clay Sphere)
    final headRect = Rect.fromCenter(center: center, width: 210, height: 195);
    final headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.28, -0.38),
        radius: 0.9,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF8FAFC),
          Color(0xFFF1F5F9),
          Color(0xFFCBD5E1),
        ],
        stops: [0.0, 0.4, 0.75, 1.0],
      ).createShader(headRect);
    canvas.drawOval(headRect, headPaint);

    // Head Specular
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(-40, -40), width: 95, height: 75),
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withValues(alpha: 0.65), Colors.white.withValues(alpha: 0.0)],
        ).createShader(headRect),
    );

    // 3D Soft Cheeks Muzzle
    final muzzleRect = Rect.fromCenter(center: center + const Offset(0, 34), width: 125, height: 70);
    canvas.drawRRect(
      RRect.fromRectAndRadius(muzzleRect, const Radius.circular(35)),
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
        ).createShader(muzzleRect),
    );

    // Panda Black Eye Patches (3D Shaded Oval)
    void drawEyePatch(Offset patchCenter, double angle) {
      canvas.save();
      canvas.translate(patchCenter.dx, patchCenter.dy);
      canvas.rotate(angle);
      final r = Rect.fromCenter(center: Offset.zero, width: 44, height: 56);
      final p = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.2, -0.3),
          colors: [Color(0xFF475569), Color(0xFF1E293B), Color(0xFF0F172A)],
        ).createShader(r);
      canvas.drawOval(r, p);
      canvas.restore();
    }

    drawEyePatch(center + const Offset(-44, -14), -0.28);
    drawEyePatch(center + const Offset(44, -14), 0.28);

    // Eyes inside patches (tracking food!)
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-44, -14),
      rightPos: center + const Offset(44, -14),
      radius: 14,
    );

    // 3D Black Panda Nose
    final noseRect = Rect.fromCenter(center: center + const Offset(0, 20), width: 26, height: 16);
    final nosePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        colors: [Color(0xFF334155), Color(0xFF0F172A)],
      ).createShader(noseRect);
    canvas.drawRRect(RRect.fromRectAndRadius(noseRect, const Radius.circular(8)), nosePaint);
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 17), width: 10, height: 4),
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );

    // Rosy Blush
    final blushPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFDA4AF).withValues(alpha: 0.6), const Color(0xFFFDA4AF).withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: center + const Offset(-65, 32), radius: 20));
    canvas.drawCircle(center + const Offset(-65, 32), 20, blushPaint);
    canvas.drawCircle(center + const Offset(65, 32), 20, blushPaint);

    // 3D Mouth & Jaw (Mangap dinamis!)
    _draw3DInteractiveMouth(canvas, center + const Offset(0, 48));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // ==========================================
  // 4. KELINCI (SI FLUFFY) 3D VECTOR
  // ==========================================
  void _paintRabbit(Canvas canvas, Offset center, Size size) {
    // 3D Floor Shadow
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 105), width: 190, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.16),
    );

    // 3D Long Ears
    void drawRabbitEar(Offset earBase, double angle, bool isLeft) {
      canvas.save();
      canvas.translate(earBase.dx, earBase.dy);
      canvas.rotate(angle);

      // Outer 3D Ear
      final earRect = Rect.fromCenter(center: const Offset(0, -60), width: 44, height: 125);
      final earPaint = Paint()
        ..shader = LinearGradient(
          begin: isLeft ? Alignment.topLeft : Alignment.topRight,
          end: isLeft ? Alignment.bottomRight : Alignment.bottomLeft,
          colors: const [Color(0xFFFFFFFF), Color(0xFFF1F5F9), Color(0xFFCBD5E1)],
        ).createShader(earRect);
      canvas.drawRRect(RRect.fromRectAndRadius(earRect, const Radius.circular(24)), earPaint);

      // Inner Soft Pink Velvet
      final innerRect = Rect.fromCenter(center: const Offset(0, -60), width: 24, height: 100);
      final innerPaint = Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFDF2F8), Color(0xFFF472B6), Color(0xFFDB2777)],
        ).createShader(innerRect);
      canvas.drawRRect(RRect.fromRectAndRadius(innerRect, const Radius.circular(14)), innerPaint);

      canvas.restore();
    }

    drawRabbitEar(center + const Offset(-42, -60), -0.18, true);
    drawRabbitEar(center + const Offset(42, -60), 0.18, false);

    // 3D Spherical Head (Snow Soft Bunny)
    final headRect = Rect.fromCenter(center: center, width: 195, height: 180);
    final headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.28, -0.38),
        radius: 0.9,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFFAF5FF),
          Color(0xFFF1F5F9),
          Color(0xFFE2E8F0),
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(headRect);
    canvas.drawOval(headRect, headPaint);

    // Specular Highlight
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(-35, -35), width: 90, height: 70),
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withValues(alpha: 0.7), Colors.white.withValues(alpha: 0.0)],
        ).createShader(headRect),
    );

    // 3D Expressive Glossy Eyes (Ruby/Pinkish-black shine)
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-42, -14),
      rightPos: center + const Offset(42, -14),
      radius: 17,
    );

    // 3D Pink Heart/Button Nose
    final noseRect = Rect.fromCenter(center: center + const Offset(0, 16), width: 18, height: 13);
    final nosePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF472B6), Color(0xFFBE185D)],
      ).createShader(noseRect);
    canvas.drawRRect(RRect.fromRectAndRadius(noseRect, const Radius.circular(6)), nosePaint);

    // Rosy Cheek Blush
    final blushPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFF472B6).withValues(alpha: 0.5), const Color(0xFFF472B6).withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: center + const Offset(-56, 24), radius: 18));
    canvas.drawCircle(center + const Offset(-56, 24), 18, blushPaint);
    canvas.drawCircle(center + const Offset(56, 24), 18, blushPaint);

    // 3D Interactive Rabbit Mouth (with cute bunny buck teeth!)
    _draw3DRabbitMouth(canvas, center + const Offset(0, 42));

    // Whiskers
    _draw3DWhiskers(canvas, center);

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  void _draw3DRabbitMouth(Canvas canvas, Offset mouthCenter) {
    double openFactor = 0.0;
    if (state == AnimalAnimationState.anticipating) {
      openFactor = 0.85;
    } else if (dragDistance != null && state != AnimalAnimationState.rejected && state != AnimalAnimationState.chewing) {
      openFactor = ((250.0 - dragDistance!) / 200.0).clamp(0.0, 1.0);
    } else if (state == AnimalAnimationState.chewing) {
      openFactor = math.sin(chewProgress * math.pi) * 0.45;
    }

    if (openFactor > 0.08) {
      // Mouth Open Wide
      final mouthWidth = 40.0 + (openFactor * 20.0);
      final mouthHeight = 16.0 + (openFactor * 38.0);
      final mouthRect = Rect.fromCenter(
        center: mouthCenter + Offset(0, openFactor * 6.0),
        width: mouthWidth,
        height: mouthHeight,
      );

      final cavityPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -0.2),
          colors: [Color(0xFF881337), Color(0xFF4C0519), Color(0xFF1E030B)],
        ).createShader(mouthRect);
      canvas.drawRRect(RRect.fromRectAndRadius(mouthRect, Radius.circular(mouthHeight * 0.48)), cavityPaint);

      // Cute Pink Tongue
      final tongueRect = Rect.fromCenter(
        center: Offset(mouthCenter.dx, mouthRect.bottom - mouthHeight * 0.3),
        width: mouthWidth * 0.65,
        height: mouthHeight * 0.4,
      );
      canvas.drawOval(
        tongueRect,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFFDA4AF), Color(0xFFF43F5E)],
          ).createShader(tongueRect),
      );

      // Two Cute Bunny Buck Teeth
      final toothPaint = Paint()..color = Colors.white;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: mouthCenter + Offset(-5, -mouthHeight * 0.28 + (openFactor * 6)), width: 8, height: 12), const Radius.circular(2)),
        toothPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: mouthCenter + Offset(5, -mouthHeight * 0.28 + (openFactor * 6)), width: 8, height: 12), const Radius.circular(2)),
        toothPaint,
      );
    } else {
      // Cute Rabbit Smile with Bunny Teeth peeking out
      final toothPaint = Paint()..color = Colors.white;
      final borderPaint = Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      final t1 = Rect.fromLTWH(mouthCenter.dx - 8, mouthCenter.dy - 2, 7.5, 11);
      final t2 = Rect.fromLTWH(mouthCenter.dx + 0.5, mouthCenter.dy - 2, 7.5, 11);
      canvas.drawRRect(RRect.fromRectAndRadius(t1, const Radius.circular(2)), toothPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(t1, const Radius.circular(2)), borderPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(t2, const Radius.circular(2)), toothPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(t2, const Radius.circular(2)), borderPaint);

      final smilePaint = Paint()
        ..color = const Color(0xFF475569)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final leftCurl = Path()
        ..moveTo(mouthCenter.dx, mouthCenter.dy - 6)
        ..lineTo(mouthCenter.dx, mouthCenter.dy)
        ..cubicTo(mouthCenter.dx, mouthCenter.dy + 10, mouthCenter.dx - 16, mouthCenter.dy + 10, mouthCenter.dx - 16, mouthCenter.dy + 2);
      canvas.drawPath(leftCurl, smilePaint);

      final rightCurl = Path()
        ..moveTo(mouthCenter.dx, mouthCenter.dy)
        ..cubicTo(mouthCenter.dx, mouthCenter.dy + 10, mouthCenter.dx + 16, mouthCenter.dy + 10, mouthCenter.dx + 16, mouthCenter.dy + 2);
      canvas.drawPath(rightCurl, smilePaint);
    }
  }

  // ==========================================
  // 5. IKAN MAS KOKI (SI MAS KOKI) 3D VECTOR
  // ==========================================
  void _paintFish(Canvas canvas, Offset center, Size size) {
    // 3D Water Bubbles
    final bubblePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFFE0F2FE), Color(0xFF38BDF8), Color(0xFF0284C7)],
      ).createShader(Rect.fromCircle(center: center, radius: 100));

    final bubbleTwitch = math.sin(breatheProgress * math.pi * 2) * 4.0;
    canvas.drawCircle(center + Offset(-85, -75 + bubbleTwitch), 14, bubblePaint);
    canvas.drawCircle(center + Offset(-65, -100 - bubbleTwitch), 9, bubblePaint);
    canvas.drawCircle(center + Offset(95, -65 + bubbleTwitch), 16, bubblePaint);

    // 3D Tail Fin (Waving in 3D volume)
    final tailWiggle = math.sin(breatheProgress * math.pi * 2) * 8.0;
    final tailPath = Path()
      ..moveTo(center.dx + 55, center.dy)
      ..cubicTo(center.dx + 90, center.dy - 55 + tailWiggle, center.dx + 130, center.dy - 40 + tailWiggle, center.dx + 125, center.dy - 10 + tailWiggle)
      ..cubicTo(center.dx + 100, center.dy, center.dx + 130, center.dy + 35 - tailWiggle, center.dx + 115, center.dy + 45 - tailWiggle)
      ..close();

    final tailPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFFB923C), Color(0xFFF97316), Color(0xFFEA580C)],
      ).createShader(Rect.fromLTWH(center.dx + 55, center.dy - 50, 75, 100));
    canvas.drawPath(tailPath, tailPaint);

    // 3D Dorsal Top Fin
    final topFinPath = Path()
      ..moveTo(center.dx - 25, center.dy - 65)
      ..cubicTo(center.dx + 5, center.dy - 105, center.dx + 45, center.dy - 95, center.dx + 48, center.dy - 58)
      ..close();
    canvas.drawPath(topFinPath, tailPaint);

    // 3D Chubby Fish Body (Glossy Pearl Gold/Orange Sphere)
    final bodyRect = Rect.fromCenter(center: center, width: 165, height: 145);
    final bodyPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.28, -0.38),
        radius: 0.9,
        colors: [
          Color(0xFFFEF08A), // Highlight gold
          Color(0xFFFDBA74), // Warm amber
          Color(0xFFF97316), // Vivid orange
          Color(0xFFC2410C), // Deep crimson rim
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(bodyRect);
    canvas.drawOval(bodyRect, bodyPaint);

    // Specular Highlight Glaze
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(-28, -28), width: 75, height: 55),
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withValues(alpha: 0.7), Colors.white.withValues(alpha: 0.0)],
        ).createShader(bodyRect),
    );

    // 3D Side Fin
    final sideFinPath = Path()
      ..moveTo(center.dx + 15, center.dy + 12)
      ..cubicTo(center.dx + 45, center.dy + 28, center.dx + 40, center.dy + 45, center.dx + 15, center.dy + 42)
      ..close();
    canvas.drawPath(sideFinPath, Paint()..color = const Color(0xFFEA580C));

    // 3D Big Expressive Glossy Fish Eye
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-28, -18),
      rightPos: center + const Offset(-28, -18),
      radius: 20,
    );

    // 3D Dynamic Pouted Fish Mouth (Mangap O-Shape saat didekati makanan!)
    _draw3DFishMouth(canvas, center + const Offset(-75, 12));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  void _draw3DFishMouth(Canvas canvas, Offset mouthCenter) {
    double openFactor = 0.0;
    if (state == AnimalAnimationState.anticipating) {
      openFactor = 0.9;
    } else if (dragDistance != null && state != AnimalAnimationState.rejected && state != AnimalAnimationState.chewing) {
      openFactor = ((250.0 - dragDistance!) / 200.0).clamp(0.0, 1.0);
    } else if (state == AnimalAnimationState.chewing) {
      openFactor = math.sin(chewProgress * math.pi) * 0.5;
    }

    final mouthHeight = 16.0 + (openFactor * 32.0);
    final mouthWidth = 18.0 + (openFactor * 10.0);

    // Outer Pouted Lips 3D
    final lipRect = Rect.fromCenter(center: mouthCenter, width: mouthWidth, height: mouthHeight);
    final lipPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFB923C), Color(0xFFEA580C), Color(0xFF9A3412)],
      ).createShader(lipRect);
    canvas.drawOval(lipRect, lipPaint);

    // Inner Deep Mouth Hole
    if (openFactor > 0.05) {
      final holeRect = Rect.fromCenter(center: mouthCenter + const Offset(-2, 0), width: mouthWidth * 0.65, height: mouthHeight * 0.68);
      canvas.drawOval(
        holeRect,
        Paint()
          ..shader = const RadialGradient(
            colors: [Color(0xFF881337), Color(0xFF4C0519), Color(0xFF1E030B)],
          ).createShader(holeRect),
      );
    }
  }

  // ==========================================
  // HELPER: Cartoon Eyes
  // ==========================================
  void _drawCartoonEyes(
    Canvas canvas, {
    required Offset leftEyePos,
    required Offset rightEyePos,
    required double eyeRadius,
    required bool isHappy,
    required bool isShocked,
    Color pupilColor = const Color(0xFF1E293B),
    bool singleEye = false,
  }) {
    final eyeWhite = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = pupilColor;
    final highlightPaint = Paint()..color = Colors.white;

    void drawOneEye(Offset pos) {
      if (isHappy) {
        // Happy curved arc eyes (^_^)
        final arcPaint = Paint()
          ..color = const Color(0xFF1E293B)
          ..strokeWidth = 3.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCenter(center: pos, width: eyeRadius * 2, height: eyeRadius * 1.5),
          math.pi,
          math.pi,
          false,
          arcPaint,
        );
      } else if (isShocked) {
        // Spiral or wide shocked eye (O_O)
        canvas.drawCircle(pos, eyeRadius * 1.3, eyeWhite);
        canvas.drawCircle(pos, 4, Paint()..color = const Color(0xFFEF4444)); // tiny red pupil
      } else {
        // Normal alive eye with pupil tracking
        canvas.drawCircle(pos, eyeRadius, eyeWhite);

        final pupilPos = pos + Offset(eyeOffsetX, eyeOffsetY);
        canvas.drawCircle(pupilPos, eyeRadius * 0.55, pupilPaint);
        // Highlight reflection
        canvas.drawCircle(pupilPos - const Offset(2.5, 2.5), eyeRadius * 0.2, highlightPaint);
      }
    }

    drawOneEye(leftEyePos);
    if (!singleEye) {
      drawOneEye(rightEyePos);
    }
  }

  // ==========================================
  // HELPER: Mouth
  // ==========================================
  void _drawMouth(
    Canvas canvas, {
    required Offset centerPos,
    required bool isAnticipating,
    required bool isChewing,
    required bool isRejected,
  }) {
    if (isAnticipating) {
      // Mouth open wide awaiting food! :O
      final mouthOpen = Paint()..color = const Color(0xFF881337);
      canvas.drawOval(
        Rect.fromCenter(center: centerPos + const Offset(0, 4), width: 36, height: 32),
        mouthOpen,
      );
      // Tongue
      final tongue = Paint()..color = const Color(0xFFFB7185);
      canvas.drawOval(
        Rect.fromCenter(center: centerPos + const Offset(0, 14), width: 22, height: 12),
        tongue,
      );
    } else if (isChewing) {
      // Chewing smile (squished)
      final mouthPaint = Paint()
        ..color = const Color(0xFF881337)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCenter(center: centerPos, width: 28, height: 16),
        0,
        math.pi,
        false,
        mouthPaint,
      );
    } else if (isRejected) {
      // Wavy / squiggly mouth :S or tongue out
      final rejectedPaint = Paint()
        ..color = const Color(0xFF991B1B)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final path = Path()
        ..moveTo(centerPos.dx - 16, centerPos.dy + 8)
        ..quadraticBezierTo(centerPos.dx - 8, centerPos.dy - 2, centerPos.dx, centerPos.dy + 6)
        ..quadraticBezierTo(centerPos.dx + 8, centerPos.dy + 14, centerPos.dx + 16, centerPos.dy + 4);
      canvas.drawPath(path, rejectedPaint);
    } else {
      // Default cute smile :)
      final smilePaint = Paint()
        ..color = const Color(0xFF78350F)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCenter(center: centerPos, width: 24, height: 14),
        0.2,
        math.pi - 0.4,
        false,
        smilePaint,
      );
    }
  }

  // =========================================================================
  // SPICY OVERLAY: RED OVERHEATED FACE, STEAM/SMOKE FROM EARS, SWEAT DROPS
  // =========================================================================
  void _drawSpicyEffects(Canvas canvas, Offset center, Size size) {
    // 1. Red Overheated Facial Flush Aura (Glowing Red Heat Wave)
    final heatPulse = (math.sin(spicyProgress * math.pi * 12) * 0.15 + 0.85);
    final heatRect = Rect.fromCircle(center: center, radius: 105);
    final heatAuraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFEF4444).withValues(alpha: 0.45 * heatPulse),
          const Color(0xFFDC2626).withValues(alpha: 0.35 * heatPulse),
          const Color(0xFFF97316).withValues(alpha: 0.15 * heatPulse),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 0.75, 1.0],
      ).createShader(heatAuraPaintBounds(center));
    canvas.drawCircle(center, 125, heatAuraPaint);

    // 2. Fiery Forehead Heat Symbol
    final fireScale = 0.8 + (math.sin(spicyProgress * math.pi * 10).abs() * 0.35);
    _drawFlameIcon(canvas, center + const Offset(0, -85), fireScale);

    // 3. Steam/Smoke Puffs billow out from Left & Right Ears / Head
    // Left ear steam origin & Right ear steam origin
    final leftEarOrigin = Offset(center.dx - 82, center.dy - 100);
    final rightEarOrigin = Offset(center.dx + 82, center.dy - 100);

    _drawEarSteamPlume(canvas, leftEarOrigin, isLeft: true);
    _drawEarSteamPlume(canvas, rightEarOrigin, isLeft: false);

    // 4. Hot Flying Sweat Droplets popping off cheeks
    _drawSweatDrops(canvas, center);
  }

  Rect heatAuraPaintBounds(Offset center) => Rect.fromCircle(center: center, radius: 125);

  void _drawEarSteamPlume(Canvas canvas, Offset origin, {required bool isLeft}) {
    // Multi-puff expanding animated steam
    final direction = isLeft ? -1.0 : 1.0;
    final t = spicyProgress * 4.0; // cycle multiple times

    for (int i = 0; i < 4; i++) {
      final puffProgress = (t + (i * 0.28)) % 1.0;
      final distance = puffProgress * 65.0;
      final puffRadius = 9.0 + (puffProgress * 18.0);
      final alpha = ((1.0 - puffProgress) * 0.85).clamp(0.0, 1.0);

      final puffCenter = Offset(
        origin.dx + (direction * (distance * 0.85 + math.sin(puffProgress * math.pi * 2) * 6)),
        origin.dy - (distance * 1.1),
      );

      // Cloud puff circle
      final puffPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: alpha),
            const Color(0xFFF1F5F9).withValues(alpha: alpha * 0.9),
            const Color(0xFFE2E8F0).withValues(alpha: alpha * 0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 0.85, 1.0],
        ).createShader(Rect.fromCircle(center: puffCenter, radius: puffRadius));

      canvas.drawCircle(puffCenter, puffRadius, puffPaint);

      // Little extra puff tufts for cloud shape
      canvas.drawCircle(
        puffCenter + Offset(direction * puffRadius * 0.4, -puffRadius * 0.2),
        puffRadius * 0.7,
        puffPaint,
      );
      canvas.drawCircle(
        puffCenter + Offset(-direction * puffRadius * 0.3, puffRadius * 0.2),
        puffRadius * 0.6,
        puffPaint,
      );
    }

    // Jet / Whistle line exiting ear
    final jetPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(origin, origin + Offset(direction * 18, -16), jetPaint);
    canvas.drawLine(origin + const Offset(0, 6), origin + Offset(direction * 14, -6), jetPaint);
  }

  void _drawFlameIcon(Canvas canvas, Offset center, double scale) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    // Outer Red Flame
    final outerFlame = Path()
      ..moveTo(0, -22)
      ..cubicTo(12, -10, 16, 4, 8, 16)
      ..cubicTo(3, 20, -3, 20, -8, 16)
      ..cubicTo(-16, 4, -12, -10, 0, -22)
      ..close();
    final outerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xFFDC2626), Color(0xFFF97316), Color(0xFFEF4444)],
      ).createShader(const Rect.fromLTWH(-16, -22, 32, 42));
    canvas.drawPath(outerFlame, outerPaint);

    // Inner Yellow Core
    final innerFlame = Path()
      ..moveTo(0, -10)
      ..cubicTo(6, -2, 8, 6, 4, 14)
      ..cubicTo(1, 17, -1, 17, -4, 14)
      ..cubicTo(-8, 6, -6, -2, 0, -10)
      ..close();
    final innerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xFFFBBF24), Color(0xFFFEF08A)],
      ).createShader(const Rect.fromLTWH(-8, -10, 16, 27));
    canvas.drawPath(innerFlame, innerPaint);

    canvas.restore();
  }

  void _drawSweatDrops(Canvas canvas, Offset center) {
    final sweatPhase = (spicyProgress * 6.0) % 1.0;
    final dropY = sweatPhase * 24.0;
    final dropAlpha = (1.0 - sweatPhase).clamp(0.0, 1.0);

    final dropPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: dropAlpha * 0.95);

    void drawDrop(Offset pos) {
      final dropPath = Path()
        ..moveTo(pos.dx, pos.dy - 8)
        ..cubicTo(pos.dx + 6, pos.dy, pos.dx + 5, pos.dy + 8, pos.dx, pos.dy + 8)
        ..cubicTo(pos.dx - 5, pos.dy + 8, pos.dx - 6, pos.dy, pos.dx, pos.dy - 8)
        ..close();
      canvas.drawPath(dropPath, dropPaint);
      canvas.drawCircle(pos + const Offset(-1.5, 3), 1.5, Paint()..color = Colors.white);
    }

    drawDrop(center + Offset(-78, -8 + dropY));
    drawDrop(center + Offset(78, -14 + dropY));
  }

  // =========================================================================
  // 6. SINGA 3D VECTOR (SI SIMBA - GOLDEN MANE, PROUD EARS, GLOSSY NOSE)
  // =========================================================================
  void _paint3DLion(Canvas canvas, Offset center, Size size) {
    // 3D Ambient Floor Shadow
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 210, height: 30),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.22),
    );

    // Lush 3D Golden Fur Mane (Radial petaled mane encircling the head)
    final maneRect = Rect.fromCircle(center: center, radius: 106);
    final manePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.95,
        colors: [Color(0xFFF59E0B), Color(0xFFD97706), Color(0xFF92400E), Color(0xFF451A03)],
        stops: [0.0, 0.45, 0.8, 1.0],
      ).createShader(maneRect);

    for (int i = 0; i < 16; i++) {
      final angle = (i * 2 * math.pi) / 16;
      final tuftPos = center + Offset(math.cos(angle) * 88, math.sin(angle) * 88);
      canvas.drawCircle(tuftPos, 32, manePaint);
    }
    canvas.drawCircle(center, 94, manePaint);

    // Lion Round Ears with Dark Brown Border
    void drawLionEar(Offset earPos) {
      canvas.drawCircle(earPos, 26, Paint()..color = const Color(0xFFB45309));
      canvas.drawCircle(earPos, 16, Paint()..color = const Color(0xFFFDE68A));
    }
    drawLionEar(center + const Offset(-68, -62));
    drawLionEar(center + const Offset(68, -62));

    // Lion Head Sphere
    final headRect = Rect.fromCircle(center: center, radius: 76);
    final headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.85,
        colors: [Color(0xFFFEF08A), Color(0xFFFBBF24), Color(0xFFD97706)],
        stops: [0.0, 0.45, 1.0],
      ).createShader(headRect);
    canvas.drawCircle(center, 76, headPaint);

    // Specular Glaze on Forehead
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(-24, -28), width: 55, height: 35),
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );

    // 3D Muzzle Cheeks
    final muzzleRect = Rect.fromCenter(center: center + const Offset(0, 24), width: 88, height: 52);
    canvas.drawRRect(
      RRect.fromRectAndRadius(muzzleRect, const Radius.circular(26)),
      Paint()..color = const Color(0xFFFEFCE8),
    );

    // 3D Expressive Gaze Tracking Eyes
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-34, -14),
      rightPos: center + const Offset(34, -14),
      radius: 17,
    );

    // Big Brown Lion Nose
    final noseRect = Rect.fromCenter(center: center + const Offset(0, 14), width: 28, height: 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(noseRect, const Radius.circular(9)),
      Paint()..color = const Color(0xFF78350F),
    );

    // 3D Interactive Mouth
    _draw3DInteractiveMouth(canvas, center + const Offset(0, 40));

    // Whiskers
    _draw3DWhiskers(canvas, center + const Offset(0, 6));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 7. HARIMAU 3D VECTOR (SI BELANG - TIGER STRIPES, WHITE MUZZLE, FIERCE CUTE)
  // =========================================================================
  void _paint3DTiger(Canvas canvas, Offset center, Size size) {
    // 3D Ambient Floor Shadow
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 200, height: 28),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.2),
    );

    // Tiger Round Ears
    void drawTigerEar(Offset pos, bool isLeft) {
      canvas.drawCircle(pos, 28, Paint()..color = const Color(0xFFEA580C));
      canvas.drawCircle(pos, 16, Paint()..color = Colors.white);
      // Black stripe on ear tip
      final tipPaint = Paint()..color = const Color(0xFF0F172A);
      canvas.drawCircle(pos + Offset(0, -18), 10, tipPaint);
    }
    drawTigerEar(center + const Offset(-62, -62), true);
    drawTigerEar(center + const Offset(62, -62), false);

    // Tiger Head Sphere (Vibrant Orange with Ambient Occlusion)
    final headRect = Rect.fromCircle(center: center, radius: 80);
    final headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.85,
        colors: [Color(0xFFFDBA74), Color(0xFFF97316), Color(0xFFC2410C)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(headRect);
    canvas.drawCircle(center, 80, headPaint);

    // Characteristic Black Tiger Stripes
    final stripePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    // Forehead Stripes (King character 王 mark)
    final stripe1 = Path()
      ..moveTo(center.dx - 8, center.dy - 68)
      ..lineTo(center.dx + 8, center.dy - 68)
      ..lineTo(center.dx, center.dy - 46)
      ..close();
    canvas.drawPath(stripe1, stripePaint);

    final stripeLeft = Path()
      ..moveTo(center.dx - 22, center.dy - 56)
      ..lineTo(center.dx - 8, center.dy - 50)
      ..lineTo(center.dx - 20, center.dy - 44)
      ..close();
    canvas.drawPath(stripeLeft, stripePaint);

    final stripeRight = Path()
      ..moveTo(center.dx + 22, center.dy - 56)
      ..lineTo(center.dx + 8, center.dy - 50)
      ..lineTo(center.dx + 20, center.dy - 44)
      ..close();
    canvas.drawPath(stripeRight, stripePaint);

    // Cheek Stripes
    void drawCheekStripe(Offset p, bool isLeft) {
      final s = Path()
        ..moveTo(p.dx, p.dy - 6)
        ..lineTo(p.dx + (isLeft ? 22 : -22), p.dy)
        ..lineTo(p.dx, p.dy + 6)
        ..close();
      canvas.drawPath(s, stripePaint);
    }
    drawCheekStripe(center + const Offset(-74, -4), true);
    drawCheekStripe(center + const Offset(-70, 14), true);
    drawCheekStripe(center + const Offset(74, -4), false);
    drawCheekStripe(center + const Offset(70, 14), false);

    // White Puffy Muzzle
    final muzzleRect = Rect.fromCenter(center: center + const Offset(0, 24), width: 90, height: 50);
    canvas.drawRRect(
      RRect.fromRectAndRadius(muzzleRect, const Radius.circular(25)),
      Paint()..color = Colors.white,
    );

    // Gaze Tracking 3D Eyes
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-36, -14),
      rightPos: center + const Offset(36, -14),
      radius: 17,
    );

    // Soft Pink Button Tiger Nose
    _draw3DNose(canvas, center + const Offset(0, 14));

    // 3D Mouth & Jaw
    _draw3DInteractiveMouth(canvas, center + const Offset(0, 38));

    // Whiskers
    _draw3DWhiskers(canvas, center + const Offset(0, 6));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 8. ARCHETYPE 3D VECTOR (SMART PIXAR RENDERING FOR ALL OTHER ANIMALS)
  // Renders a claymorphic 3D head with animal avatar glyph, gaze tracking eyes,
  // 3D muzzle, and fully interactive real-time mouth!
  // =========================================================================
  // =========================================================================
  // 8. BEBEK 3D VECTOR (SI KWEK - ROUND YELLOW HEAD, ORANGE DUCK BILL)
  // =========================================================================
  void _paint3DDuck(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 190, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.18),
    );

    // Cute duck tuft on head
    final tuftPath = Path()
      ..moveTo(center.dx - 6, center.dy - 76)
      ..cubicTo(center.dx - 14, center.dy - 100, center.dx + 6, center.dy - 98, center.dx + 4, center.dy - 78)
      ..close();
    canvas.drawPath(tuftPath, Paint()..color = const Color(0xFFEAB308));

    // Duck Head Sphere
    final headRect = Rect.fromCircle(center: center, radius: 78);
    final headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.85,
        colors: [Color(0xFFFEF08A), Color(0xFFFACC15), Color(0xFFCA8A04)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(headRect);
    canvas.drawCircle(center, 78, headPaint);

    // Big Glossy Duck Eyes
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-32, -14),
      rightPos: center + const Offset(32, -14),
      radius: 17,
    );

    // Cheek Blush
    final blush = Paint()..color = const Color(0xFFFB923C).withValues(alpha: 0.45);
    canvas.drawCircle(center + const Offset(-52, 10), 14, blush);
    canvas.drawCircle(center + const Offset(52, 10), 14, blush);

    // Duck Broad Bill (Mouth)
    final billRect = Rect.fromCenter(center: center + const Offset(0, 24), width: 72, height: 38);
    final billPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        colors: [Color(0xFFFED7AA), Color(0xFFFB923C), Color(0xFFEA580C)],
      ).createShader(billRect);
    canvas.drawRRect(RRect.fromRectAndRadius(billRect, const Radius.circular(19)), billPaint);

    // Nostrils
    canvas.drawCircle(center + const Offset(-8, 16), 2.5, Paint()..color = const Color(0xFF9A3412));
    canvas.drawCircle(center + const Offset(8, 16), 2.5, Paint()..color = const Color(0xFF9A3412));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 36));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 9. SAPI 3D VECTOR (SI MUMU - COW HORNS, SPOTS, PINK MUZZLE)
  // =========================================================================
  void _paint3DCow(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 200, height: 28),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.2),
    );

    // Cow Horns
    void drawHorn(Offset p, bool isLeft) {
      final h = Path()
        ..moveTo(p.dx - (isLeft ? 8 : -8), p.dy + 12)
        ..cubicTo(p.dx - (isLeft ? 26 : -26), p.dy - 20, p.dx - (isLeft ? 10 : -10), p.dy - 34, p.dx, p.dy - 36)
        ..cubicTo(p.dx - (isLeft ? 4 : -4), p.dy - 20, p.dx + (isLeft ? 4 : -4), p.dy - 6, p.dx + (isLeft ? 8 : -8), p.dy + 12)
        ..close();
      canvas.drawPath(h, Paint()..color = const Color(0xFFFDE68A));
    }
    drawHorn(center + const Offset(-52, -58), true);
    drawHorn(center + const Offset(52, -58), false);

    // Drooping Cow Ears
    void drawCowEar(Offset p, bool isLeft) {
      final earRect = Rect.fromCenter(center: p, width: 44, height: 24);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(isLeft ? -0.28 : 0.28);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 44, height: 24), Paint()..color = const Color(0xFFE2E8F0));
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 28, height: 14), Paint()..color = const Color(0xFFFDA4AF));
      canvas.restore();
    }
    drawCowEar(center + const Offset(-72, -36), true);
    drawCowEar(center + const Offset(72, -36), false);

    // Cow Head (White Sphere with Black Spot)
    final headRect = Rect.fromCircle(center: center, radius: 78);
    final headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.85,
        colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9), Color(0xFFCBD5E1)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(headRect);
    canvas.drawCircle(center, 78, headPaint);

    // Black Cow Eye Spot
    final spotPath = Path()
      ..addOval(Rect.fromCenter(center: center + const Offset(-34, -14), width: 48, height: 52));
    canvas.drawPath(spotPath, Paint()..color = const Color(0xFF1E293B));

    // Eyes
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-34, -14),
      rightPos: center + const Offset(34, -14),
      radius: 16,
    );

    // Wide Oval Pink Cow Muzzle
    final muzzleRect = Rect.fromCenter(center: center + const Offset(0, 32), width: 104, height: 54);
    final muzzlePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        colors: [Color(0xFFFCE7F3), Color(0xFFF472B6), Color(0xFFDB2777)],
      ).createShader(muzzleRect);
    canvas.drawRRect(RRect.fromRectAndRadius(muzzleRect, const Radius.circular(27)), muzzlePaint);

    // Cow Nostrils
    canvas.drawOval(Rect.fromCenter(center: center + const Offset(-20, 26), width: 12, height: 16), Paint()..color = const Color(0xFF831843));
    canvas.drawOval(Rect.fromCenter(center: center + const Offset(20, 26), width: 12, height: 16), Paint()..color = const Color(0xFF831843));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 44));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 10. MONYET 3D VECTOR (SI MIKO - ROUND EARS, PEACH FACE, WIDE SMILE)
  // =========================================================================
  void _paint3DMonkey(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 190, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.2),
    );

    // Big Protruding Round Ears
    void drawMonkeyEar(Offset p) {
      canvas.drawCircle(p, 34, Paint()..color = const Color(0xFF92400E));
      canvas.drawCircle(p, 22, Paint()..color = const Color(0xFFFDE68A));
    }
    drawMonkeyEar(center + const Offset(-80, -10));
    drawMonkeyEar(center + const Offset(80, -10));

    // Outer Brown Head
    final headRect = Rect.fromCircle(center: center, radius: 76);
    canvas.drawCircle(center, 76, Paint()..color = const Color(0xFF78350F));

    // Peach Heart/Mask Face (Inner face)
    final faceMask = Path()
      ..addOval(Rect.fromCenter(center: center + const Offset(-26, -18), width: 52, height: 56))
      ..addOval(Rect.fromCenter(center: center + const Offset(26, -18), width: 52, height: 56))
      ..addOval(Rect.fromCenter(center: center + const Offset(0, 18), width: 88, height: 60));
    canvas.drawPath(faceMask, Paint()..color = const Color(0xFFFED7AA));

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-28, -16),
      rightPos: center + const Offset(28, -16),
      radius: 16,
    );

    _draw3DNose(canvas, center + const Offset(0, 8));
    _draw3DInteractiveMouth(canvas, center + const Offset(0, 36));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 11. DOMBA 3D VECTOR (SI MBEK - FLUFFY WOOL PUFFS, SOFT MUZZLE)
  // =========================================================================
  void _paint3DSheep(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 195, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.18),
    );

    // Wool Cloud around head
    final woolPaint = Paint()..color = const Color(0xFFF1F5F9);
    for (int i = 0; i < 14; i++) {
      final angle = (i * 2 * math.pi) / 14;
      final pos = center + Offset(math.cos(angle) * 78, math.sin(angle) * 78);
      canvas.drawCircle(pos, 28, woolPaint);
    }
    canvas.drawCircle(center, 80, woolPaint);

    // Floppy Drooping Dark Ears
    void drawSheepEar(Offset p, bool isLeft) {
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(isLeft ? 0.35 : -0.35);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 36, height: 18), Paint()..color = const Color(0xFF64748B));
      canvas.restore();
    }
    drawSheepEar(center + const Offset(-72, -18), true);
    drawSheepEar(center + const Offset(72, -18), false);

    // Inner Sheep Face (Slate grey/tan oval)
    final faceRect = Rect.fromCenter(center: center + const Offset(0, 10), width: 92, height: 96);
    canvas.drawRRect(RRect.fromRectAndRadius(faceRect, const Radius.circular(38)), Paint()..color = const Color(0xFF475569));

    // Wool Forehead Cap
    canvas.drawCircle(center + const Offset(-18, -42), 18, woolPaint);
    canvas.drawCircle(center + const Offset(0, -48), 20, woolPaint);
    canvas.drawCircle(center + const Offset(18, -42), 18, woolPaint);

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-28, -6),
      rightPos: center + const Offset(28, -6),
      radius: 14,
    );

    // Pink Nose
    canvas.drawCircle(center + const Offset(0, 22), 8, Paint()..color = const Color(0xFFFDA4AF));
    _draw3DInteractiveMouth(canvas, center + const Offset(0, 42));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 12. BURUNG HANTU 3D VECTOR (SI HOOT - BIG OCULAR DISCS, SHARP BEAK)
  // =========================================================================
  void _paint3DOwl(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 185, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.2),
    );

    // Owl Ear Feather Tufts
    final leftTuft = Path()
      ..moveTo(center.dx - 48, center.dy - 60)
      ..lineTo(center.dx - 64, center.dy - 106)
      ..lineTo(center.dx - 28, center.dy - 74)
      ..close();
    canvas.drawPath(leftTuft, Paint()..color = const Color(0xFF78350F));

    final rightTuft = Path()
      ..moveTo(center.dx + 48, center.dy - 60)
      ..lineTo(center.dx + 64, center.dy - 106)
      ..lineTo(center.dx + 28, center.dy - 74)
      ..close();
    canvas.drawPath(rightTuft, Paint()..color = const Color(0xFF78350F));

    // Brown Head Sphere
    final headRect = Rect.fromCircle(center: center, radius: 78);
    canvas.drawCircle(center, 78, Paint()..color = const Color(0xFF92400E));

    // Giant Facial Discs (Ocular feather circles)
    canvas.drawCircle(center + const Offset(-34, -10), 32, Paint()..color = const Color(0xFFFEF3C7));
    canvas.drawCircle(center + const Offset(34, -10), 32, Paint()..color = const Color(0xFFFEF3C7));

    // Big Golden Eyes
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-34, -10),
      rightPos: center + const Offset(34, -10),
      radius: 20,
    );

    // Sharp Triangle Beak
    final beak = Path()
      ..moveTo(center.dx - 12, center.dy + 6)
      ..lineTo(center.dx + 12, center.dy + 6)
      ..lineTo(center.dx, center.dy + 30)
      ..close();
    canvas.drawPath(beak, Paint()..color = const Color(0xFFF59E0B));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 36));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 13. BURUNG PIPIT 3D VECTOR (SI PIPIT - SKY BLUE, POINTY BEAK)
  // =========================================================================
  void _paint3DBird(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 175, height: 24),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.18),
    );

    // Cute feather crest
    final crest = Path()
      ..moveTo(center.dx - 10, center.dy - 72)
      ..cubicTo(center.dx - 16, center.dy - 100, center.dx + 8, center.dy - 102, center.dx + 10, center.dy - 72)
      ..close();
    canvas.drawPath(crest, Paint()..color = const Color(0xFF0284C7));

    // Blue Bird Head Sphere
    final headRect = Rect.fromCircle(center: center, radius: 76);
    final headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        colors: [Color(0xFF7DD3FC), Color(0xFF0284C7), Color(0xFF0369A1)],
      ).createShader(headRect);
    canvas.drawCircle(center, 76, headPaint);

    // White Cheeks
    canvas.drawCircle(center + const Offset(-42, 6), 18, Paint()..color = Colors.white.withValues(alpha: 0.9));
    canvas.drawCircle(center + const Offset(42, 6), 18, Paint()..color = Colors.white.withValues(alpha: 0.9));

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-28, -14),
      rightPos: center + const Offset(28, -14),
      radius: 16,
    );

    // Sharp Orange Cone Beak
    final beak = Path()
      ..moveTo(center.dx - 12, center.dy + 4)
      ..lineTo(center.dx + 12, center.dy + 4)
      ..lineTo(center.dx, center.dy + 26)
      ..close();
    canvas.drawPath(beak, Paint()..color = const Color(0xFFF97316));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 32));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 14. KUDA 3D VECTOR (SI KSATRIA - ERECT EARS, BLAZE, DARK MANE)
  // =========================================================================
  void _paint3DHorse(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 195, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.2),
    );

    // Tall Pointy Ears
    void drawHorseEar(Offset p, bool isLeft) {
      final ear = Path()
        ..moveTo(p.dx - 14, p.dy + 18)
        ..lineTo(p.dx, p.dy - 34)
        ..lineTo(p.dx + 14, p.dy + 18)
        ..close();
      canvas.drawPath(ear, Paint()..color = const Color(0xFF92400E));
      canvas.drawPath(ear, Paint()..color = const Color(0xFFFDE68A)..strokeWidth = 3..style = PaintingStyle.stroke);
    }
    drawHorseEar(center + const Offset(-46, -64), true);
    drawHorseEar(center + const Offset(46, -64), false);

    // Dark Brown Mane Crest
    for (int y = -82; y <= -40; y += 12) {
      canvas.drawCircle(center + Offset(0, y.toDouble()), 18, Paint()..color = const Color(0xFF451A03));
    }

    // Horse Head (Elongated Chestnut Oval)
    final headRect = Rect.fromCenter(center: center, width: 140, height: 160);
    canvas.drawRRect(RRect.fromRectAndRadius(headRect, const Radius.circular(55)), Paint()..color = const Color(0xFFB45309));

    // White Star/Blaze on Forehead
    final blaze = Path()
      ..moveTo(center.dx, center.dy - 44)
      ..lineTo(center.dx + 12, center.dy - 10)
      ..lineTo(center.dx, center.dy + 10)
      ..lineTo(center.dx - 12, center.dy - 10)
      ..close();
    canvas.drawPath(blaze, Paint()..color = Colors.white);

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-42, -18),
      rightPos: center + const Offset(42, -18),
      radius: 16,
    );

    // Dark Snout / Muzzle
    final snoutRect = Rect.fromCenter(center: center + const Offset(0, 42), width: 88, height: 48);
    canvas.drawRRect(RRect.fromRectAndRadius(snoutRect, const Radius.circular(24)), Paint()..color = const Color(0xFF78350F));

    // Nostrils
    canvas.drawCircle(center + const Offset(-18, 38), 6, Paint()..color = const Color(0xFF451A03));
    canvas.drawCircle(center + const Offset(18, 38), 6, Paint()..color = const Color(0xFF451A03));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 52));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 15. ANJING 3D VECTOR (SI MILO - FLOPPY EARS, SHINY BLACK NOSE)
  // =========================================================================
  void _paint3DDog(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 195, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.2),
    );

    // Floppy Drooping Ears
    void drawDogEar(Offset p, bool isLeft) {
      final earRect = Rect.fromCenter(center: p, width: 42, height: 74);
      canvas.drawRRect(RRect.fromRectAndRadius(earRect, const Radius.circular(21)), Paint()..color = const Color(0xFF78350F));
    }
    drawDogEar(center + const Offset(-74, -14), true);
    drawDogEar(center + const Offset(74, -14), false);

    // Warm Caramel Dog Head
    final headRect = Rect.fromCircle(center: center, radius: 78);
    canvas.drawCircle(center, 78, Paint()..color = const Color(0xFFD97706));

    // White Puffy Muzzle
    final muzzleRect = Rect.fromCenter(center: center + const Offset(0, 22), width: 88, height: 54);
    canvas.drawRRect(RRect.fromRectAndRadius(muzzleRect, const Radius.circular(27)), Paint()..color = const Color(0xFFFFFBEB));

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-34, -14),
      rightPos: center + const Offset(34, -14),
      radius: 17,
    );

    // Big Shiny Black Nose
    final noseRect = Rect.fromCenter(center: center + const Offset(0, 12), width: 28, height: 18);
    canvas.drawRRect(RRect.fromRectAndRadius(noseRect, const Radius.circular(9)), Paint()..color = const Color(0xFF0F172A));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 38));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 16. KOALA 3D VECTOR (SI KOKO - FUZZY ROUND EARS, BIG OVAL BLACK NOSE)
  // =========================================================================
  void _paint3DKoala(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 195, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.18),
    );

    // Giant Fluffy Fuzzy Ears
    void drawKoalaEar(Offset p) {
      canvas.drawCircle(p, 36, Paint()..color = const Color(0xFF94A3B8));
      canvas.drawCircle(p, 24, Paint()..color = Colors.white);
    }
    drawKoalaEar(center + const Offset(-72, -44));
    drawKoalaEar(center + const Offset(72, -44));

    // Grey Head Sphere
    final headRect = Rect.fromCircle(center: center, radius: 78);
    canvas.drawCircle(center, 78, Paint()..color = const Color(0xFF64748B));

    // Cheeks
    canvas.drawCircle(center + const Offset(-46, 18), 16, Paint()..color = const Color(0xFFFDA4AF).withValues(alpha: 0.4));
    canvas.drawCircle(center + const Offset(46, 18), 16, Paint()..color = const Color(0xFFFDA4AF).withValues(alpha: 0.4));

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-34, -12),
      rightPos: center + const Offset(34, -12),
      radius: 15,
    );

    // Characteristic Giant Oval Black Koala Nose
    final noseRect = Rect.fromCenter(center: center + const Offset(0, 16), width: 34, height: 46);
    canvas.drawRRect(RRect.fromRectAndRadius(noseRect, const Radius.circular(17)), Paint()..color = const Color(0xFF0F172A));

    // Nose Highlight
    canvas.drawOval(Rect.fromCenter(center: center + const Offset(-5, 4), width: 12, height: 8), Paint()..color = Colors.white.withValues(alpha: 0.35));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 48));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 17. PINGUIN 3D VECTOR (SI PIKO - EMPEROR PENGUIN HOOD, WINGS, WEBBED FEET, BEAK)
  // =========================================================================
  void _paint3DPenguin(Canvas canvas, Offset center, Size size) {
    // 1. Ice / Ground Shadow
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 105), width: 180, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.22),
    );

    // 2. Bright Orange Webbed Penguin Feet at Bottom
    void drawWebbedFoot(Offset footCenter, double angle) {
      canvas.save();
      canvas.translate(footCenter.dx, footCenter.dy);
      canvas.rotate(angle);

      final footPath = Path()
        ..moveTo(-16, -4)
        ..lineTo(-22, 16)
        ..lineTo(-8, 13)
        ..lineTo(0, 17)
        ..lineTo(8, 13)
        ..lineTo(22, 16)
        ..lineTo(16, -4)
        ..close();

      final footRect = Rect.fromCenter(center: Offset.zero, width: 44, height: 22);
      final footPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFBBF24), Color(0xFFF97316), Color(0xFFEA580C)],
        ).createShader(footRect);
      canvas.drawPath(footPath, footPaint);
      canvas.restore();
    }
    drawWebbedFoot(center + const Offset(-38, 96), -0.22);
    drawWebbedFoot(center + const Offset(38, 96), 0.22);

    // 3. Side Flippers / Penguin Wings (Resting or Flapping slightly)
    void drawFlipper(Offset shoulder, bool isLeft) {
      canvas.save();
      canvas.translate(shoulder.dx, shoulder.dy);
      final flipperAngle = isLeft ? -0.32 : 0.32;
      canvas.rotate(flipperAngle);

      final flipperPath = Path()
        ..moveTo(0, 0)
        ..cubicTo(isLeft ? -30 : 30, 25, isLeft ? -36 : 36, 75, isLeft ? -10 : 10, 95)
        ..cubicTo(isLeft ? -4 : 4, 75, 0, 40, 0, 0)
        ..close();

      final flipperRect = Rect.fromLTWH(isLeft ? -40 : 0, 0, 40, 100);
      final flipperPaint = Paint()
        ..shader = LinearGradient(
          begin: isLeft ? Alignment.centerRight : Alignment.centerLeft,
          end: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          colors: const [Color(0xFF1E293B), Color(0xFF0F172A), Color(0xFF020617)],
        ).createShader(flipperRect);
      canvas.drawPath(flipperPath, flipperPaint);

      // White inner flipper edge
      final innerEdge = Path()
        ..moveTo(isLeft ? -6 : 6, 20)
        ..cubicTo(isLeft ? -18 : 18, 45, isLeft ? -18 : 18, 75, isLeft ? -10 : 10, 92);
      canvas.drawPath(
        innerEdge,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      canvas.restore();
    }
    drawFlipper(center + const Offset(-68, -10), true);
    drawFlipper(center + const Offset(68, -10), false);

    // 4. Characteristic Egg-shaped Emperor Tuxedo Body (Dark Navy / Black)
    final bodyRect = Rect.fromCenter(center: center + const Offset(0, 12), width: 148, height: 172);
    final bodyPath = Path()
      ..moveTo(center.dx, center.dy - 74) // Top of head
      ..cubicTo(center.dx + 55, center.dy - 74, center.dx + 74, center.dy - 20, center.dx + 74, center.dy + 35)
      ..cubicTo(center.dx + 74, center.dy + 85, center.dx + 48, center.dy + 98, center.dx, center.dy + 98)
      ..cubicTo(center.dx - 48, center.dy + 98, center.dx - 74, center.dy + 85, center.dx - 74, center.dy + 35)
      ..cubicTo(center.dx - 74, center.dy - 20, center.dx - 55, center.dy - 74, center.dx, center.dy - 74)
      ..close();

    final bodyPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.45),
        radius: 0.95,
        colors: [Color(0xFF334155), Color(0xFF0F172A), Color(0xFF020617)],
        stops: [0.0, 0.65, 1.0],
      ).createShader(bodyRect);
    canvas.drawPath(bodyPath, bodyPaint);

    // 5. Golden / Yellow Auricular Ear Patches (Emperor Penguin Golden Feather Glow)
    final leftGoldPatch = Path()
      ..moveTo(center.dx - 44, center.dy - 40)
      ..cubicTo(center.dx - 64, center.dy - 25, center.dx - 62, center.dy + 5, center.dx - 42, center.dy - 5)
      ..close();
    final rightGoldPatch = Path()
      ..moveTo(center.dx + 44, center.dy - 40)
      ..cubicTo(center.dx + 64, center.dy - 25, center.dx + 62, center.dy + 5, center.dx + 42, center.dy - 5)
      ..close();
    final goldPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B), Color(0xFFEA580C)],
      ).createShader(Rect.fromLTWH(center.dx - 70, center.dy - 45, 140, 55));
    canvas.drawPath(leftGoldPatch, goldPaint);
    canvas.drawPath(rightGoldPatch, goldPaint);

    // 6. Plump White Belly & Heart-shaped Face Mask
    final bellyPath = Path()
      ..moveTo(center.dx, center.dy - 32)
      // Heart curves around eyes
      ..cubicTo(center.dx + 26, center.dy - 58, center.dx + 52, center.dy - 30, center.dx + 46, center.dy + 15)
      ..cubicTo(center.dx + 54, center.dy + 55, center.dx + 38, center.dy + 90, center.dx, center.dy + 90)
      ..cubicTo(center.dx - 38, center.dy + 90, center.dx - 54, center.dy + 55, center.dx - 46, center.dy + 15)
      ..cubicTo(center.dx - 52, center.dy - 30, center.dx - 26, center.dy - 58, center.dx, center.dy - 32)
      ..close();

    final bellyRect = Rect.fromCenter(center: center + const Offset(0, 25), width: 110, height: 140);
    final bellyPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.0, -0.2),
        radius: 0.9,
        colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
        stops: [0.0, 0.75, 1.0],
      ).createShader(bellyRect);
    canvas.drawPath(bellyPath, bellyPaint);

    // Cute Soft Pink Cheeks
    canvas.drawCircle(center + const Offset(-34, 4), 11, Paint()..color = const Color(0xFFFDA4AF).withValues(alpha: 0.65));
    canvas.drawCircle(center + const Offset(34, 4), 11, Paint()..color = const Color(0xFFFDA4AF).withValues(alpha: 0.65));

    // 7. Expressive 3D Glossy Eyes
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-22, -18),
      rightPos: center + const Offset(22, -18),
      radius: 14,
    );

    // 8. 3D Triangular Penguin Beak (with top ridge highlight & dark tip)
    final beakTop = center + const Offset(0, -6);
    final beakPath = Path()
      ..moveTo(beakTop.dx - 15, beakTop.dy)
      ..cubicTo(beakTop.dx - 12, beakTop.dy - 4, beakTop.dx + 12, beakTop.dy - 4, beakTop.dx + 15, beakTop.dy)
      ..lineTo(beakTop.dx + 13, beakTop.dy + 4)
      ..cubicTo(beakTop.dx + 5, beakTop.dy + 18, beakTop.dx - 5, beakTop.dy + 18, beakTop.dx - 13, beakTop.dy + 4)
      ..close();

    final beakRect = Rect.fromCenter(center: beakTop + const Offset(0, 6), width: 32, height: 24);
    final beakPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFDE047), Color(0xFFF97316), Color(0xFFC2410C)],
      ).createShader(beakRect);
    canvas.drawPath(beakPath, beakPaint);

    // Beak Specular Glaze
    final beakGlaze = Path()
      ..moveTo(beakTop.dx - 8, beakTop.dy)
      ..lineTo(beakTop.dx + 8, beakTop.dy)
      ..lineTo(beakTop.dx, beakTop.dy + 6)
      ..close();
    canvas.drawPath(beakGlaze, Paint()..color = Colors.white.withValues(alpha: 0.6));

    // 9. Interactive Mouth for feeding
    _draw3DInteractiveMouth(canvas, center + const Offset(0, 24));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 18. TUPAI 3D VECTOR (SI CIKI - BUSHY TAIL BEHIND, BUCK TEETH)
  // =========================================================================
  void _paint3DSquirrel(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 195, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.2),
    );

    // Giant Bushy Tail curled behind right shoulder
    final tailPath = Path()
      ..moveTo(center.dx + 35, center.dy + 40)
      ..cubicTo(center.dx + 90, center.dy + 50, center.dx + 135, center.dy - 40, center.dx + 105, center.dy - 95)
      ..cubicTo(center.dx + 75, center.dy - 125, center.dx + 30, center.dy - 90, center.dx + 55, center.dy - 60)
      ..cubicTo(center.dx + 75, center.dy - 40, center.dx + 65, center.dy + 10, center.dx + 25, center.dy + 20)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFF9A3412));

    // Pointy Squirrel Ears with tufts
    void drawSquirrelEar(Offset p) {
      final ear = Path()
        ..moveTo(p.dx - 12, p.dy + 14)
        ..lineTo(p.dx, p.dy - 28)
        ..lineTo(p.dx + 12, p.dy + 14)
        ..close();
      canvas.drawPath(ear, Paint()..color = const Color(0xFFC2410C));
    }
    drawSquirrelEar(center + const Offset(-44, -58));
    drawSquirrelEar(center + const Offset(44, -58));

    // Head Sphere
    canvas.drawCircle(center, 76, Paint()..color = const Color(0xFFEA580C));

    // Cream Cheeks
    canvas.drawCircle(center + const Offset(-38, 18), 24, Paint()..color = const Color(0xFFFFFBEB));
    canvas.drawCircle(center + const Offset(38, 18), 24, Paint()..color = const Color(0xFFFFFBEB));

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-32, -14),
      rightPos: center + const Offset(32, -14),
      radius: 17,
    );

    // Little Dark Nose
    _draw3DNose(canvas, center + const Offset(0, 10));

    // Buck Teeth
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center + const Offset(-4, 30), width: 7, height: 12), const Radius.circular(2)), Paint()..color = Colors.white);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center + const Offset(4, 30), width: 7, height: 12), const Radius.circular(2)), Paint()..color = Colors.white);

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 36));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 19. JERAPAH 3D VECTOR (SI JERAPAH - OSSICONES/HORNS, SPOTS, TALL FACE)
  // =========================================================================
  void _paint3DGiraffe(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 195, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.2),
    );

    // Ossicones (Giraffe Horns with Knob on top)
    void drawOssicone(Offset p) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: p, width: 12, height: 44), const Radius.circular(6)), Paint()..color = const Color(0xFFF59E0B));
      canvas.drawCircle(p - const Offset(0, 24), 10, Paint()..color = const Color(0xFF78350F));
    }
    drawOssicone(center + const Offset(-28, -72));
    drawOssicone(center + const Offset(28, -72));

    // Giraffe Ears sticking outwards
    void drawGiraffeEar(Offset p, bool isLeft) {
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(isLeft ? -0.45 : 0.45);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 44, height: 20), Paint()..color = const Color(0xFFFBBF24));
      canvas.restore();
    }
    drawGiraffeEar(center + const Offset(-72, -44), true);
    drawGiraffeEar(center + const Offset(72, -44), false);

    // Warm Yellow Head
    final headRect = Rect.fromCenter(center: center, width: 136, height: 160);
    canvas.drawRRect(RRect.fromRectAndRadius(headRect, const Radius.circular(54)), Paint()..color = const Color(0xFFFBBF24));

    // Brown Spots
    canvas.drawCircle(center + const Offset(-34, -40), 12, Paint()..color = const Color(0xFFB45309));
    canvas.drawCircle(center + const Offset(36, -38), 10, Paint()..color = const Color(0xFFB45309));
    canvas.drawCircle(center + const Offset(0, -32), 14, Paint()..color = const Color(0xFFB45309));

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-36, -14),
      rightPos: center + const Offset(36, -14),
      radius: 17,
    );

    // Tan Muzzle
    final snoutRect = Rect.fromCenter(center: center + const Offset(0, 36), width: 84, height: 50);
    canvas.drawRRect(RRect.fromRectAndRadius(snoutRect, const Radius.circular(25)), Paint()..color = const Color(0xFFFEF3C7));

    _draw3DNose(canvas, center + const Offset(0, 26));
    _draw3DInteractiveMouth(canvas, center + const Offset(0, 48));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 20. GAJAH 3D VECTOR (SI GANI - GIANT EARS, PROMINENT TRUNK)
  // =========================================================================
  void _paint3DElephant(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 210, height: 30),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.22),
    );

    // Giant Flapping Elephant Ears
    void drawElephantEar(Offset p, bool isLeft) {
      final earRect = Rect.fromCenter(center: p, width: 88, height: 110);
      canvas.drawOval(earRect, Paint()..color = const Color(0xFF94A3B8));
      canvas.drawOval(Rect.fromCenter(center: p, width: 60, height: 80), Paint()..color = const Color(0xFFFDA4AF).withValues(alpha: 0.45));
    }
    drawElephantEar(center + const Offset(-82, -10), true);
    drawElephantEar(center + const Offset(82, -10), false);

    // Slate Grey Head
    final headRect = Rect.fromCircle(center: center, radius: 80);
    canvas.drawCircle(center, 80, Paint()..color = const Color(0xFF64748B));

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-38, -18),
      rightPos: center + const Offset(38, -18),
      radius: 16,
    );

    // White Tusks
    final leftTusk = Path()
      ..moveTo(center.dx - 22, center.dy + 18)
      ..cubicTo(center.dx - 36, center.dy + 38, center.dx - 34, center.dy + 58, center.dx - 22, center.dy + 46)
      ..close();
    canvas.drawPath(leftTusk, Paint()..color = Colors.white);

    final rightTusk = Path()
      ..moveTo(center.dx + 22, center.dy + 18)
      ..cubicTo(center.dx + 36, center.dy + 38, center.dx + 34, center.dy + 58, center.dx + 22, center.dy + 46)
      ..close();
    canvas.drawPath(rightTusk, Paint()..color = Colors.white);

    // Long Curled Elephant Trunk (Belalai)
    final trunkPath = Path()
      ..moveTo(center.dx - 18, center.dy + 8)
      ..cubicTo(center.dx - 24, center.dy + 45, center.dx - 10, center.dy + 78, center.dx + 15, center.dy + 74)
      ..cubicTo(center.dx + 30, center.dy + 72, center.dx + 25, center.dy + 58, center.dx + 12, center.dy + 56)
      ..cubicTo(center.dx + 4, center.dy + 54, center.dx + 4, center.dy + 35, center.dx + 18, center.dy + 8)
      ..close();
    canvas.drawPath(trunkPath, Paint()..color = const Color(0xFF475569));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 40));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 21. KATAK 3D VECTOR (SI KODOK - PROTRUDING DOME EYES, WIDE SMILE)
  // =========================================================================
  void _paint3DFrog(Canvas canvas, Offset center, Size size) {
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 110), width: 195, height: 26),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.18),
    );

    // Two Big Bulging Eye Domes on top
    canvas.drawCircle(center + const Offset(-44, -48), 34, Paint()..color = const Color(0xFF16A34A));
    canvas.drawCircle(center + const Offset(44, -48), 34, Paint()..color = const Color(0xFF16A34A));

    // Green Wide Head Oval
    final headRect = Rect.fromCenter(center: center + const Offset(0, 6), width: 172, height: 136);
    canvas.drawOval(headRect, Paint()..color = const Color(0xFF22C55E));

    // Cream Belly / Throat
    final bellyRect = Rect.fromCenter(center: center + const Offset(0, 36), width: 110, height: 72);
    canvas.drawOval(bellyRect, Paint()..color = const Color(0xFFFEF9C3));

    // Big Eyes inside domes
    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-44, -48),
      rightPos: center + const Offset(44, -48),
      radius: 20,
    );

    // Little Nostril Dots
    canvas.drawCircle(center + const Offset(-8, -4), 2.5, Paint()..color = const Color(0xFF14532D));
    canvas.drawCircle(center + const Offset(8, -4), 2.5, Paint()..color = const Color(0xFF14532D));

    _draw3DInteractiveMouth(canvas, center + const Offset(0, 24));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  // =========================================================================
  // 22. LUMBA-LUMBA 3D VECTOR (SI LUMBA - SMOOTH BOTTLE NOSE, DORSAL FIN)
  // =========================================================================
  void _paint3DDolphin(Canvas canvas, Offset center, Size size) {
    // Water Splash Bubbles
    canvas.drawCircle(center + const Offset(-85, -70), 12, Paint()..color = const Color(0xFFBAE6FD));
    canvas.drawCircle(center + const Offset(90, -60), 14, Paint()..color = const Color(0xFFBAE6FD));

    // Top Dorsal Fin
    final dorsal = Path()
      ..moveTo(center.dx - 10, center.dy - 68)
      ..cubicTo(center.dx + 15, center.dy - 110, center.dx + 45, center.dy - 95, center.dx + 40, center.dy - 56)
      ..close();
    canvas.drawPath(dorsal, Paint()..color = const Color(0xFF0369A1));

    // Side Flippers
    final flipperLeft = Path()
      ..moveTo(center.dx - 60, center.dy + 15)
      ..cubicTo(center.dx - 98, center.dy + 30, center.dx - 88, center.dy + 50, center.dx - 55, center.dy + 35)
      ..close();
    canvas.drawPath(flipperLeft, Paint()..color = const Color(0xFF0284C7));

    // Smooth Sleek Dolphin Body
    final bodyRect = Rect.fromCenter(center: center, width: 160, height: 140);
    canvas.drawOval(bodyRect, Paint()..color = const Color(0xFF38BDF8));

    // White Belly
    final bellyRect = Rect.fromCenter(center: center + const Offset(0, 26), width: 115, height: 80);
    canvas.drawOval(bellyRect, Paint()..color = Colors.white);

    // Dolphin Beak / Snout (Bottle nose)
    final snout = Path()
      ..moveTo(center.dx - 30, center.dy + 4)
      ..cubicTo(center.dx - 60, center.dy + 10, center.dx - 65, center.dy + 32, center.dx - 25, center.dy + 32)
      ..close();
    canvas.drawPath(snout, Paint()..color = const Color(0xFF38BDF8));

    _draw3DGlossyEyes(
      canvas,
      leftPos: center + const Offset(-20, -18),
      rightPos: center + const Offset(32, -18),
      radius: 16,
    );

    _draw3DInteractiveMouth(canvas, center + const Offset(-15, 24));

    if (state == AnimalAnimationState.chewing) {
      _drawChewingStars(canvas, center);
    }
  }

  @override
  bool shouldRepaint(covariant _Animal3DVectorPainter oldDelegate) => true;
}
