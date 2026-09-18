import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/tree_garden_models.dart';

class MagicalTree3DView extends StatefulWidget {
  final TreeProfile tree;
  final TreeGrowthStage stage;
  final double wateringProgress; // 0.0 to 1.0 (water droplets flowing)
  final double growthProgress;   // 0.0 to 1.0 (trunk & foliage scaling)
  final Set<int> harvestedFruits; // Indices of fruits harvested
  final Function(int index)? onFruitTapped;

  const MagicalTree3DView({
    super.key,
    required this.tree,
    required this.stage,
    this.wateringProgress = 0.0,
    this.growthProgress = 0.0,
    required this.harvestedFruits,
    this.onFruitTapped,
  });

  @override
  State<MagicalTree3DView> createState() => _MagicalTree3DViewState();
}

class _MagicalTree3DViewState extends State<MagicalTree3DView>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _idleController,
      builder: (context, child) {
        return SizedBox(
          width: 330,
          height: 330,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 3D Vector Tree Canvas
              CustomPaint(
                size: const Size(330, 330),
                painter: _MagicalTreePainter(
                  tree: widget.tree,
                  stage: widget.stage,
                  wateringProgress: widget.wateringProgress,
                  growthProgress: widget.growthProgress,
                  idleProgress: _idleController.value,
                  harvestedFruits: widget.harvestedFruits,
                ),
              ),

              // Interactive Fruit Tap Targets in Harvest Stage
              if (widget.stage == TreeGrowthStage.harvest || widget.stage == TreeGrowthStage.completed)
                ..._buildFruitTapOverlays(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFruitTapOverlays() {
    final List<Widget> list = [];
    final fruitPositions = _getFruitScreenPositions(widget.tree.id);

    for (int i = 0; i < fruitPositions.length; i++) {
      final isHarvested = widget.harvestedFruits.contains(i);
      final pos = fruitPositions[i];

      list.add(
        Positioned(
          left: pos.dx - 28,
          top: pos.dy - 28,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!isHarvested && widget.onFruitTapped != null) {
                widget.onFruitTapped!(i);
              }
            },
            child: SizedBox(
              width: 56,
              height: 56,
              child: isHarvested
                  ? null
                  : Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  static List<Offset> _getFruitScreenPositions(String treeId) {
    if (treeId == 'banana') {
      // Banana bunches hanging under frond crown
      return const [
        Offset(142, 108),
        Offset(165, 114),
        Offset(188, 108),
        Offset(152, 128),
        Offset(176, 128),
      ];
    } else if (treeId == 'strawberry') {
      // Low bush strawberries hanging along the rim
      return const [
        Offset(112, 185),
        Offset(145, 192),
        Offset(175, 195),
        Offset(205, 190),
        Offset(160, 168),
      ];
    } else {
      // Apple & Orange canopy distribution
      return const [
        Offset(115, 80),
        Offset(215, 85),
        Offset(165, 55),
        Offset(95, 135),
        Offset(235, 130),
      ];
    }
  }
}

class _MagicalTreePainter extends CustomPainter {
  final TreeProfile tree;
  final TreeGrowthStage stage;
  final double wateringProgress;
  final double growthProgress;
  final double idleProgress;
  final Set<int> harvestedFruits;

  _MagicalTreePainter({
    required this.tree,
    required this.stage,
    required this.wateringProgress,
    required this.growthProgress,
    required this.idleProgress,
    required this.harvestedFruits,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.72);

    // 1. 3D Floor Shadow
    _drawFloorShadow(canvas, center);

    // 2. 3D Ceramic Pot with Soil
    _draw3DPotAndSoil(canvas, center);

    // 3. Tree Life Stages
    switch (stage) {
      case TreeGrowthStage.seed:
        _drawSeedInSoil(canvas, center);
        break;
      case TreeGrowthStage.watering:
        if (growthProgress >= 0.8) {
          // Mature tree being re-watered for continuous harvest!
          _drawGrowingTree(canvas, center);
          if (wateringProgress > 0.05) {
            _drawWateringDropsOnTree(canvas, center);
          }
        } else {
          // First time sprout
          _drawWateringParticlesAndSprout(canvas, center);
        }
        break;
      case TreeGrowthStage.sunlight:
      case TreeGrowthStage.blooming:
      case TreeGrowthStage.harvest:
      case TreeGrowthStage.completed:
        _drawGrowingTree(canvas, center);
        break;
    }
  }

  void _drawWateringDropsOnTree(Canvas canvas, Offset center) {
    final dropPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFBAE6FD), Color(0xFF38BDF8), Color(0xFF0284C7)],
      ).createShader(Rect.fromLTWH(center.dx - 90, center.dy - 190, 180, 180));

    final random = math.Random(123);
    for (int i = 0; i < 24; i++) {
      final x = center.dx - 80 + random.nextDouble() * 160;
      final startY = center.dy - 180 + random.nextDouble() * 30;
      final fallDist = (wateringProgress * 140) + (i * 5);
      final y = (startY + (fallDist % 140)).clamp(center.dy - 180, center.dy + 10);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y), width: 5.0, height: 12),
          const Radius.circular(3),
        ),
        dropPaint,
      );
    }
  }

  void _drawFloorShadow(Canvas canvas, Offset center) {
    final shadowPaint = Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.18);
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 56), width: 220, height: 32),
      shadowPaint,
    );
  }

  void _draw3DPotAndSoil(Canvas canvas, Offset center) {
    // 3D Terracotta Ceramic Pot
    final potRect = Rect.fromCenter(center: center + const Offset(0, 20), width: 170, height: 75);

    // Pot Body
    final potPath = Path()
      ..moveTo(center.dx - 80, center.dy)
      ..lineTo(center.dx - 60, center.dy + 52)
      ..cubicTo(center.dx - 30, center.dy + 62, center.dx + 30, center.dy + 62, center.dx + 60, center.dy + 52)
      ..lineTo(center.dx + 80, center.dy)
      ..close();

    final potPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFEA580C),
          Color(0xFFF97316),
          Color(0xFFFB923C),
          Color(0xFFC2410C),
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(potRect);
    canvas.drawPath(potPath, potPaint);

    // Pot Rim
    final rimRect = Rect.fromCenter(center: center, width: 172, height: 26);
    final rimPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFED7AA), Color(0xFFEA580C)],
      ).createShader(rimRect);
    canvas.drawOval(rimRect, rimPaint);

    // Rich Dark Fertile Soil (Dark Chocolate 3D)
    final soilRect = Rect.fromCenter(center: center, width: 154, height: 20);
    final isWatered = stage != TreeGrowthStage.seed;
    final soilPaint = Paint()
      ..shader = RadialGradient(
        colors: isWatered
            ? const [Color(0xFF3E2723), Color(0xFF1B0000)] // Damp fertile soil
            : const [Color(0xFF795548), Color(0xFF4E342E)],
      ).createShader(soilRect);
    canvas.drawOval(soilRect, soilPaint);

    // Subtle rim specular highlight
    canvas.drawOval(
      Rect.fromCenter(center: center - const Offset(20, 2), width: 80, height: 6),
      Paint()..color = Colors.white.withValues(alpha: 0.3),
    );
  }

  void _drawSeedInSoil(Canvas canvas, Offset center) {
    // Seed resting in soil before watering
    final seedC = center - const Offset(0, 4);
    final seedRect = Rect.fromCenter(center: seedC, width: 22, height: 28);
    final seedPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFFA16207), Color(0xFF713F12), Color(0xFF451A03)],
      ).createShader(seedRect);
    canvas.drawOval(seedRect, seedPaint);

    // Specular highlight
    canvas.drawOval(
      Rect.fromCenter(center: seedC - const Offset(3, 4), width: 6, height: 9),
      Paint()..color = Colors.white.withValues(alpha: 0.4),
    );
  }

  void _drawWateringParticlesAndSprout(Canvas canvas, Offset center) {
    // Water droplets spraying downwards
    if (wateringProgress > 0.05) {
      final dropPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBAE6FD), Color(0xFF38BDF8), Color(0xFF0284C7)],
        ).createShader(Rect.fromLTWH(center.dx - 60, center.dy - 120, 120, 120));

      final random = math.Random(42);
      for (int i = 0; i < 18; i++) {
        final x = center.dx - 55 + random.nextDouble() * 110;
        final startY = center.dy - 110 + random.nextDouble() * 20;
        final fallDist = (wateringProgress * 110) + (i * 4);
        final y = (startY + (fallDist % 110)).clamp(center.dy - 110, center.dy - 2);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(x, y), width: 4.5, height: 11),
            const Radius.circular(3),
          ),
          dropPaint,
        );
      }
    }

    // Cute Green Sprout emerging!
    final sproutScale = (wateringProgress * 1.2).clamp(0.2, 1.0);
    _drawCuteSprout(canvas, center, sproutScale);
  }

  void _drawCuteSprout(Canvas canvas, Offset center, double scale) {
    canvas.save();
    canvas.translate(center.dx, center.dy - 2);
    canvas.scale(scale);

    // Sprout Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF84CC16)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, const Offset(0, -32), stemPaint);

    // Left Leaf
    final leftLeaf = Path()
      ..moveTo(0, -32)
      ..cubicTo(-24, -42, -26, -18, 0, -22)
      ..close();
    canvas.drawPath(leftLeaf, Paint()..color = const Color(0xFF65A30D));

    // Right Leaf
    final rightLeaf = Path()
      ..moveTo(0, -32)
      ..cubicTo(24, -42, 26, -18, 0, -22)
      ..close();
    canvas.drawPath(rightLeaf, Paint()..color = const Color(0xFF84CC16));

    canvas.restore();
  }

  void _drawGrowingTree(Canvas canvas, Offset center) {
    final t = growthProgress.clamp(0.0, 1.0);
    final sway = math.sin(idleProgress * math.pi * 2) * 3.5;

    switch (tree.id) {
      case 'banana':
        _drawBananaPlant(canvas, center, t, sway);
        break;
      case 'strawberry':
        _drawStrawberryPlant(canvas, center, t, sway);
        break;
      case 'orange':
      case 'apple':
      default:
        _drawStandardFruitTree(canvas, center, t, sway);
        break;
    }
  }

  // ==========================================
  // 1. POHON PISANG (BANANA PALM) BOTANY
  // ==========================================
  void _drawBananaPlant(Canvas canvas, Offset center, double t, double sway) {
    // Smooth, thick green pseudostem
    final trunkHeight = 120.0 * (0.35 + (t * 0.65));
    final trunkTop = Offset(center.dx + (sway * 0.5), center.dy - trunkHeight);

    final stemPath = Path()
      ..moveTo(center.dx - 18, center.dy)
      ..cubicTo(center.dx - 14, center.dy - (trunkHeight * 0.5), trunkTop.dx - 11, trunkTop.dy + 10, trunkTop.dx - 8, trunkTop.dy)
      ..lineTo(trunkTop.dx + 8, trunkTop.dy)
      ..cubicTo(trunkTop.dx + 11, trunkTop.dy + 10, center.dx + 14, center.dy - (trunkHeight * 0.5), center.dx + 18, center.dy)
      ..close();

    final stemPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [Color(0xFF4D7C0F), Color(0xFF84CC16), Color(0xFFA3E635), Color(0xFF3F6212)],
        stops: const [0.0, 0.35, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(center.dx - 20, trunkTop.dy, 40, trunkHeight));
    canvas.drawPath(stemPath, stemPaint);

    // Stem ring segments
    final ringPaint = Paint()
      ..color = const Color(0xFF365314).withValues(alpha: 0.35)
      ..strokeWidth = 2.0;
    for (double y = center.dy - 20; y > trunkTop.dy + 15; y -= 24) {
      canvas.drawLine(Offset(center.dx - 14, y), Offset(center.dx + 14, y - 4), ringPaint);
    }

    // Arching Wide Palm/Banana Fronds
    final frondScale = 0.3 + (t * 0.7);
    _drawBananaFronds(canvas, trunkTop, frondScale, sway);

    // Blooming Banana Heart (Jantung Pisang)
    if (stage == TreeGrowthStage.blooming) {
      _drawBananaHeart(canvas, trunkTop + const Offset(0, 18), frondScale);
    }

    // Banana Bunches / Hands (Sisir Pisang)
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      _drawHangingBananaHands(canvas);
    }
  }

  void _drawBananaFronds(Canvas canvas, Offset crownCenter, double scale, double sway) {
    // 6 Large Arching Glossy Fronds
    final frondAngles = [
      -math.pi * 0.82,
      -math.pi * 0.58,
      -math.pi * 0.42,
      -math.pi * 0.18,
      -math.pi * 0.95,
      -math.pi * 0.05,
    ];

    for (int i = 0; i < frondAngles.length; i++) {
      final angle = frondAngles[i] + (sway * 0.015);
      final frondLength = 95.0 * scale;

      canvas.save();
      canvas.translate(crownCenter.dx, crownCenter.dy);
      canvas.rotate(angle);

      final frondPath = Path()
        ..moveTo(0, 0)
        ..cubicTo(frondLength * 0.35, -18 * scale, frondLength * 0.75, -22 * scale, frondLength, 0)
        ..cubicTo(frondLength * 0.75, 22 * scale, frondLength * 0.35, 18 * scale, 0, 0)
        ..close();

      final frondPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: i % 2 == 0
              ? const [Color(0xFF65A30D), Color(0xFF4D7C0F), Color(0xFF365314)]
              : const [Color(0xFF84CC16), Color(0xFF65A30D), Color(0xFF3F6212)],
        ).createShader(Rect.fromLTWH(0, -22 * scale, frondLength, 44 * scale));
      canvas.drawPath(frondPath, frondPaint);

      // Center Frond Midrib Spine
      final spinePaint = Paint()
        ..color = const Color(0xFFBEF264)
        ..strokeWidth = 2.5 * scale
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset.zero, Offset(frondLength * 0.92, 0), spinePaint);

      canvas.restore();
    }
  }

  void _drawBananaHeart(Canvas canvas, Offset pos, double scale) {
    // Purple teardrop blossom
    final heartRect = Rect.fromCenter(center: pos, width: 26 * scale, height: 38 * scale);
    final heartPath = Path()
      ..moveTo(pos.dx, pos.dy - (18 * scale))
      ..cubicTo(pos.dx + (16 * scale), pos.dy, pos.dx + (8 * scale), pos.dy + (18 * scale), pos.dx, pos.dy + (20 * scale))
      ..cubicTo(pos.dx - (8 * scale), pos.dy + (18 * scale), pos.dx - (16 * scale), pos.dy, pos.dx, pos.dy - (18 * scale))
      ..close();

    final heartPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFFC084FC), Color(0xFF7E22CE), Color(0xFF3B0764)],
      ).createShader(heartRect);
    canvas.drawPath(heartPath, heartPaint);
  }

  void _drawHangingBananaHands(Canvas canvas) {
    final positions = [
      const Offset(142, 108),
      const Offset(165, 114),
      const Offset(188, 108),
      const Offset(152, 128),
      const Offset(176, 128),
    ];

    for (int i = 0; i < positions.length; i++) {
      if (harvestedFruits.contains(i)) continue;
      _drawSingleRealisticBanana(canvas, positions[i], i);
    }
  }

  void _drawSingleRealisticBanana(Canvas canvas, Offset pos, int index) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    // Alternate curve tilt
    final tilt = (index % 2 == 0) ? -0.22 : 0.18;
    canvas.rotate(tilt);

    // Realistic crescent banana curve
    final bananaPath = Path()
      ..moveTo(-12, -18)
      ..cubicTo(-14, 2, -4, 18, 14, 18)
      ..cubicTo(6, 15, -4, 2, -2, -16)
      ..close();

    final bRect = Rect.fromCenter(center: Offset.zero, width: 32, height: 40);
    final bananaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFEF08A), Color(0xFFFACC15), Color(0xFFEAB308), Color(0xFFCA8A04)],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(bRect);
    canvas.drawPath(bananaPath, bananaPaint);

    // Specular Highlight along the outer ridge
    final hlPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final hlPath = Path()
      ..moveTo(-10, -10)
      ..cubicTo(-10, 2, -2, 12, 10, 14);
    canvas.drawPath(hlPath, hlPaint);

    // Green tip & dark stem
    canvas.drawCircle(const Offset(-12, -18), 2.2, Paint()..color = const Color(0xFF65A30D));
    canvas.drawCircle(const Offset(14, 18), 1.8, Paint()..color = const Color(0xFF713F12));

    canvas.restore();
  }

  // ==========================================
  // 2. KEBUN STROBERI (STRAWBERRY BUSH) BOTANY
  // ==========================================
  void _drawStrawberryPlant(Canvas canvas, Offset center, double t, double sway) {
    final bushScale = 0.3 + (t * 0.7);

    // Compact lush ground rosette leaves (Trifoliate with serrated scalloped edges)
    canvas.save();
    canvas.translate(center.dx + (sway * 0.5), center.dy - 8);
    canvas.scale(bushScale);

    // Crown leaves radiating outward over the rim
    final leafAngles = [-2.6, -1.9, -1.2, -0.6, 0.0, 0.6, 1.2, 1.9, 2.6];
    for (int i = 0; i < leafAngles.length; i++) {
      canvas.save();
      canvas.rotate(leafAngles[i] * 0.6);

      final leafPath = Path()
        ..moveTo(0, 0)
        ..cubicTo(-28, -25, -24, -60, 0, -68)
        ..cubicTo(24, -60, 28, -25, 0, 0)
        ..close();

      final leafPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: i % 2 == 0
              ? const [Color(0xFF14532D), Color(0xFF16A34A), Color(0xFF4ADE80)]
              : const [Color(0xFF166534), Color(0xFF15803D), Color(0xFF22C55E)],
        ).createShader(const Rect.fromLTWH(-30, -70, 60, 70));
      canvas.drawPath(leafPath, leafPaint);

      // Serrated scallop veins
      final veinPaint = Paint()
        ..color = const Color(0xFF86EFAC).withValues(alpha: 0.4)
        ..strokeWidth = 1.8;
      canvas.drawLine(Offset.zero, const Offset(0, -62), veinPaint);

      canvas.restore();
    }
    canvas.restore();

    // White Strawberry Blossoms
    if (stage == TreeGrowthStage.blooming) {
      final flowerPositions = [
        Offset(center.dx - 45, center.dy - 40),
        Offset(center.dx + 45, center.dy - 38),
        Offset(center.dx, center.dy - 65),
      ];
      for (final p in flowerPositions) {
        _drawWhiteStrawberryFlower(canvas, p);
      }
    }

    // Ripe Red Conical Strawberries hanging at edge
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(112, 185),
        Offset(145, 192),
        Offset(175, 195),
        Offset(205, 190),
        Offset(160, 168),
      ];

      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSingleRealisticStrawberry(canvas, positions[i]);
      }
    }
  }

  void _drawWhiteStrawberryFlower(Canvas canvas, Offset pos) {
    // 5 Pure White Petals + Golden Center
    final petalPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi) / 5;
      final petPos = pos + Offset(math.cos(angle) * 7.5, math.sin(angle) * 7.5);
      canvas.drawCircle(petPos, 5.5, petalPaint);
    }
    // Golden Stamen
    canvas.drawCircle(pos, 4.5, Paint()..color = const Color(0xFFEAB308));
  }

  void _drawSingleRealisticStrawberry(Canvas canvas, Offset pos) {
    // 3D Conical Heart Berry with achenes (seeds) and green calyx cap
    final berryRect = Rect.fromCenter(center: pos, width: 28, height: 34);

    final berryPath = Path()
      ..moveTo(pos.dx, pos.dy - 12)
      ..cubicTo(pos.dx + 16, pos.dy - 12, pos.dx + 14, pos.dy + 8, pos.dx, pos.dy + 18)
      ..cubicTo(pos.dx - 14, pos.dy + 8, pos.dx - 16, pos.dy - 12, pos.dx, pos.dy - 12)
      ..close();

    final berryPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        colors: [Color(0xFFFDA4AF), Color(0xFFE11D48), Color(0xFF881337)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(berryRect);
    canvas.drawPath(berryPath, berryPaint);

    // Specular Highlight
    canvas.drawOval(
      Rect.fromCenter(center: pos - const Offset(4, 4), width: 8, height: 5),
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );

    // Golden Achenes (Seeds)
    final seedPaint = Paint()..color = const Color(0xFFFEF08A);
    const seedOffsets = [
      Offset(-6, -4), Offset(0, -5), Offset(6, -4),
      Offset(-4, 2), Offset(3, 2),
      Offset(-1, 8), Offset(0, 13),
    ];
    for (final so in seedOffsets) {
      canvas.drawOval(Rect.fromCenter(center: pos + so, width: 1.8, height: 2.4), seedPaint);
    }

    // Green Calyx Leaves on Top
    final calyxPaint = Paint()..color = const Color(0xFF22C55E);
    for (int c = -2; c <= 2; c++) {
      final cPath = Path()
        ..moveTo(pos.dx, pos.dy - 12)
        ..lineTo(pos.dx + (c * 6), pos.dy - 18)
        ..lineTo(pos.dx + (c * 3), pos.dy - 11)
        ..close();
      canvas.drawPath(cPath, calyxPaint);
    }
  }

  // ==========================================
  // 3. POHON APEL & JERUK (ORCHARD TREE) BOTANY
  // ==========================================
  void _drawStandardFruitTree(Canvas canvas, Offset center, double t, double sway) {
    // 1. Organic Tree Trunk with 3D Wood Texture
    final trunkHeight = 110.0 * (0.3 + (t * 0.7));
    final trunkTop = Offset(center.dx + (sway * 0.5), center.dy - trunkHeight);

    final trunkPath = Path()
      ..moveTo(center.dx - 22, center.dy)
      ..cubicTo(center.dx - 18, center.dy - (trunkHeight * 0.4), trunkTop.dx - 14, trunkTop.dy + 15, trunkTop.dx - 10, trunkTop.dy)
      ..lineTo(trunkTop.dx + 10, trunkTop.dy)
      ..cubicTo(trunkTop.dx + 14, trunkTop.dy + 15, center.dx + 18, center.dy - (trunkHeight * 0.4), center.dx + 22, center.dy)
      ..close();

    final trunkPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF5A3825), Color(0xFF8B5A2B), Color(0xFFB57A42), Color(0xFF5A3825)],
      ).createShader(Rect.fromLTWH(center.dx - 25, trunkTop.dy, 50, trunkHeight));
    canvas.drawPath(trunkPath, trunkPaint);

    // Left & Right Branches
    if (t > 0.35) {
      final branchPaint = Paint()
        ..color = const Color(0xFF78350F)
        ..strokeWidth = 10.0 * t
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(center.dx, center.dy - (trunkHeight * 0.55)),
        Offset(center.dx - (45 * t), center.dy - (trunkHeight * 0.75)),
        branchPaint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - (trunkHeight * 0.65)),
        Offset(center.dx + (48 * t), center.dy - (trunkHeight * 0.82)),
        branchPaint,
      );
    }

    // 2. Lush 3D Cloud Foliage (Green spheres with studio lighting)
    final foliageScale = (0.2 + (t * 0.8));
    final foliageCenter = trunkTop - const Offset(0, 30);

    _drawFoliageCloud(canvas, foliageCenter, foliageScale, sway);

    // 3. Blooming Flowers (in Blooming Stage)
    if (stage == TreeGrowthStage.blooming) {
      _drawBloomingFlowers(canvas, foliageCenter, foliageScale);
    }

    // 4. Ripe 3D Fruits (Apple or Orange)
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      _drawRipeFruits(canvas, foliageCenter, foliageScale);
    }
  }

  void _drawFoliageCloud(Canvas canvas, Offset center, double scale, double sway) {
    canvas.save();
    canvas.translate(center.dx + sway, center.dy);
    canvas.scale(scale);

    final foliageBalls = [
      {'pos': const Offset(-45, 10), 'r': 52.0, 'color': const Color(0xFF15803D)},
      {'pos': const Offset(45, 12), 'r': 52.0, 'color': const Color(0xFF166534)},
      {'pos': const Offset(0, -35), 'r': 58.0, 'color': const Color(0xFF16A34A)},
      {'pos': const Offset(-30, -10), 'r': 55.0, 'color': const Color(0xFF22C55E)},
      {'pos': const Offset(30, -8), 'r': 55.0, 'color': const Color(0xFF4ADE80)},
      {'pos': const Offset(0, 5), 'r': 54.0, 'color': const Color(0xFF22C55E)},
    ];

    for (final b in foliageBalls) {
      final pos = b['pos'] as Offset;
      final r = b['r'] as double;
      final c = b['color'] as Color;

      final ballRect = Rect.fromCircle(center: pos, radius: r);
      final ballPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.85,
          colors: [
            c.withValues(alpha: 0.9),
            c,
            const Color(0xFF14532D),
          ],
        ).createShader(ballRect);

      canvas.drawCircle(pos, r, ballPaint);

      canvas.drawOval(
        Rect.fromCenter(center: pos - Offset(r * 0.3, r * 0.3), width: r * 0.55, height: r * 0.35),
        Paint()..color = Colors.white.withValues(alpha: 0.32),
      );
    }

    canvas.restore();
  }

  void _drawBloomingFlowers(Canvas canvas, Offset foliageCenter, double scale) {
    const flowerPositions = [
      Offset(-48, -25),
      Offset(48, -22),
      Offset(0, -55),
      Offset(-30, 20),
      Offset(35, 18),
    ];

    for (final p in flowerPositions) {
      final pos = foliageCenter + (p * scale);
      final petalPaint = Paint()..color = const Color(0xFFFDF2F8);
      for (int i = 0; i < 5; i++) {
        final angle = (i * 2 * math.pi) / 5;
        final petOffset = pos + Offset(math.cos(angle) * 8, math.sin(angle) * 8);
        canvas.drawCircle(petOffset, 6, petalPaint);
      }
      canvas.drawCircle(pos, 5, Paint()..color = const Color(0xFFFACC15));
    }
  }

  void _drawRipeFruits(Canvas canvas, Offset foliageCenter, double scale) {
    const fruitRelativePositions = [
      Offset(-50, -28),
      Offset(50, -24),
      Offset(0, -54),
      Offset(-70, 25),
      Offset(70, 20),
    ];

    for (int i = 0; i < fruitRelativePositions.length; i++) {
      if (harvestedFruits.contains(i)) continue;

      final p = fruitRelativePositions[i];
      final fruitCenter = foliageCenter + (p * scale);

      if (tree.id == 'apple') {
        _drawSingleApple(canvas, fruitCenter);
      } else {
        _drawSingleOrange(canvas, fruitCenter);
      }
    }
  }

  void _drawSingleApple(Canvas canvas, Offset fruitCenter) {
    // Characteristic apple shape with indented top dip
    final applePath = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - 12)
      ..cubicTo(fruitCenter.dx + 15, fruitCenter.dy - 20, fruitCenter.dx + 22, fruitCenter.dy + 4, fruitCenter.dx + 12, fruitCenter.dy + 17)
      ..cubicTo(fruitCenter.dx + 4, fruitCenter.dy + 20, fruitCenter.dx - 4, fruitCenter.dy + 20, fruitCenter.dx - 12, fruitCenter.dy + 17)
      ..cubicTo(fruitCenter.dx - 22, fruitCenter.dy + 4, fruitCenter.dx - 15, fruitCenter.dy - 20, fruitCenter.dx, fruitCenter.dy - 12)
      ..close();

    final appleRect = Rect.fromCenter(center: fruitCenter, width: 40, height: 40);
    final applePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        radius: 0.85,
        colors: [Color(0xFFF87171), Color(0xFFDC2626), Color(0xFF7F1D1D)],
        stops: [0.0, 0.65, 1.0],
      ).createShader(appleRect);
    canvas.drawPath(applePath, applePaint);

    // Specular Glaze
    canvas.drawOval(
      Rect.fromCenter(center: fruitCenter - const Offset(6, 6), width: 9, height: 6),
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );

    // Stem & Green Leaf
    final stemPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(fruitCenter - const Offset(0, 12), fruitCenter - const Offset(2, 22), stemPaint);

    final leafPath = Path()
      ..moveTo(fruitCenter.dx - 1, fruitCenter.dy - 18)
      ..cubicTo(fruitCenter.dx + 9, fruitCenter.dy - 24, fruitCenter.dx + 12, fruitCenter.dy - 16, fruitCenter.dx - 1, fruitCenter.dy - 17)
      ..close();
    canvas.drawPath(leafPath, Paint()..color = const Color(0xFF4ADE80));
  }

  void _drawSingleOrange(Canvas canvas, Offset fruitCenter) {
    const radius = 18.0;
    final fruitRect = Rect.fromCircle(center: fruitCenter, radius: radius);

    // Citrus Sphere
    final orangePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        radius: 0.85,
        colors: [Color(0xFFFDBA74), Color(0xFFEA580C), Color(0xFF9A3412)],
        stops: [0.0, 0.65, 1.0],
      ).createShader(fruitRect);
    canvas.drawCircle(fruitCenter, radius, orangePaint);

    // Subtle Citrus Pores Texture
    final porePaint = Paint()..color = const Color(0xFFC2410C).withValues(alpha: 0.35);
    canvas.drawCircle(fruitCenter + const Offset(-4, 3), 1.0, porePaint);
    canvas.drawCircle(fruitCenter + const Offset(5, -2), 1.0, porePaint);
    canvas.drawCircle(fruitCenter + const Offset(2, 6), 1.0, porePaint);

    // Specular Glaze
    canvas.drawOval(
      Rect.fromCenter(center: fruitCenter - const Offset(5, 5), width: 8, height: 5),
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );

    // Button Calyx / Little Green Leaves on Top
    final calyxPaint = Paint()..color = const Color(0xFF15803D);
    canvas.drawCircle(fruitCenter - const Offset(0, radius - 2), 2.2, calyxPaint);
    final leaf = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - radius)
      ..cubicTo(fruitCenter.dx + 7, fruitCenter.dy - radius - 6, fruitCenter.dx + 9, fruitCenter.dy - radius, fruitCenter.dx, fruitCenter.dy - radius + 1)
      ..close();
    canvas.drawPath(leaf, Paint()..color = const Color(0xFF22C55E));
  }

  @override
  bool shouldRepaint(covariant _MagicalTreePainter oldDelegate) => true;
}
