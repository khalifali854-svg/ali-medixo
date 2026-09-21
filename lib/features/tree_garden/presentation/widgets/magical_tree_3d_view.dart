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
    switch (treeId) {
      case 'banana':
        // Banana bunches hanging directly under crown
        return const [
          Offset(142, 108),
          Offset(165, 114),
          Offset(188, 108),
          Offset(152, 128),
          Offset(176, 128),
        ];
      case 'coconut':
        // Coconuts clustering tight under palm crown
        return const [
          Offset(148, 92),
          Offset(166, 96),
          Offset(184, 92),
          Offset(156, 108),
          Offset(174, 108),
        ];
      case 'papaya':
        // Papayas clinging vertically to upper trunk beneath palmate leaves
        return const [
          Offset(155, 102),
          Offset(175, 106),
          Offset(152, 126),
          Offset(178, 130),
          Offset(165, 146),
        ];
      case 'strawberry':
        // Low bush strawberries hanging along the rim
        return const [
          Offset(112, 185),
          Offset(145, 192),
          Offset(175, 195),
          Offset(205, 190),
          Offset(160, 168),
        ];
      case 'watermelon':
      case 'melon':
        // Melons resting along the ground vine
        return const [
          Offset(102, 192),
          Offset(138, 188),
          Offset(165, 202),
          Offset(196, 188),
          Offset(228, 194),
        ];
      case 'pineapple':
        // Central pinecone golden fruit and basal shoots
        return const [
          Offset(165, 142),
          Offset(132, 168),
          Offset(198, 168),
          Offset(146, 186),
          Offset(184, 186),
        ];
      case 'corn':
        // Corn cobs attached to tall stalk nodes
        return const [
          Offset(140, 110),
          Offset(190, 118),
          Offset(136, 148),
          Offset(194, 154),
          Offset(165, 178),
        ];
      case 'grape':
        // Grape clusters hanging below the wooden arbor pergola
        return const [
          Offset(118, 112),
          Offset(150, 106),
          Offset(180, 106),
          Offset(212, 112),
          Offset(165, 132),
        ];
      case 'dragonfruit':
        // Dragonfruits growing on drooping cactus triangular ribs
        return const [
          Offset(114, 126),
          Offset(216, 126),
          Offset(138, 96),
          Offset(192, 96),
          Offset(165, 120),
        ];
      case 'tomato':
        // Tomatoes hanging from vine stems
        return const [
          Offset(124, 138),
          Offset(206, 138),
          Offset(140, 102),
          Offset(190, 102),
          Offset(165, 78),
        ];
      case 'blueberry':
        // Blueberries scattered over dense leafy shrub
        return const [
          Offset(120, 132),
          Offset(210, 130),
          Offset(142, 98),
          Offset(188, 98),
          Offset(165, 122),
        ];
      default:
        // Orchard Canopy distribution (Apple, Orange, Mango, Avocado, Peach, Pear, Cherry, Lemon, Kiwi, Starfruit)
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
      case 'coconut':
        _drawCoconutPalmPlant(canvas, center, t, sway);
        break;
      case 'papaya':
        _drawPapayaPlant(canvas, center, t, sway);
        break;
      case 'strawberry':
        _drawStrawberryPlant(canvas, center, t, sway);
        break;
      case 'watermelon':
      case 'melon':
        _drawMelonVinePlant(canvas, center, t, sway);
        break;
      case 'pineapple':
        _drawPineapplePlant(canvas, center, t, sway);
        break;
      case 'corn':
        _drawCornStalkPlant(canvas, center, t, sway);
        break;
      case 'grape':
        _drawGrapePergolaPlant(canvas, center, t, sway);
        break;
      case 'dragonfruit':
        _drawDragonfruitCactusPlant(canvas, center, t, sway);
        break;
      case 'tomato':
        _drawTomatoBushPlant(canvas, center, t, sway);
        break;
      case 'blueberry':
        _drawBlueberryBushPlant(canvas, center, t, sway);
        break;
      case 'orange':
      case 'apple':
      case 'mango':
      case 'avocado':
      case 'peach':
      case 'pear':
      case 'lemon':
      case 'cherry':
      case 'kiwi':
      case 'starfruit':
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
  // 3. POHON KELAPA (COCONUT PALM) BOTANY
  // ==========================================
  void _drawCoconutPalmPlant(Canvas canvas, Offset center, double t, double sway) {
    final trunkHeight = 135.0 * (0.35 + (t * 0.65));
    // Curving leaning palm trunk
    final lean = 22.0 * t;
    final trunkTop = Offset(center.dx + lean + (sway * 0.4), center.dy - trunkHeight);

    final trunkPath = Path()
      ..moveTo(center.dx - 16, center.dy)
      ..cubicTo(center.dx - 6, center.dy - (trunkHeight * 0.5), trunkTop.dx - 12, trunkTop.dy + 20, trunkTop.dx - 8, trunkTop.dy)
      ..lineTo(trunkTop.dx + 8, trunkTop.dy)
      ..cubicTo(trunkTop.dx + 12, trunkTop.dy + 20, center.dx + 16, center.dy - (trunkHeight * 0.5), center.dx + 16, center.dy)
      ..close();

    final trunkPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [Color(0xFF78350F), Color(0xFFA16207), Color(0xFFB45309), Color(0xFF451A03)],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(center.dx - 20, trunkTop.dy, 40 + lean, trunkHeight));
    canvas.drawPath(trunkPath, trunkPaint);

    // Segmented palm notches / rings
    final ringPaint = Paint()
      ..color = const Color(0xFF451A03).withValues(alpha: 0.45)
      ..strokeWidth = 2.2;
    for (double prog = 0.15; prog < 0.95; prog += 0.12) {
      final y = center.dy - (trunkHeight * prog);
      final xOffset = lean * prog;
      canvas.drawLine(Offset(center.dx - 12 + xOffset, y), Offset(center.dx + 12 + xOffset, y - 2), ringPaint);
    }

    // Feathered Arching Palm Fronds
    final frondScale = 0.3 + (t * 0.7);
    final frondAngles = [-2.8, -2.2, -1.6, -1.0, -0.4, 0.1, -3.1];
    for (int i = 0; i < frondAngles.length; i++) {
      final angle = frondAngles[i] + (sway * 0.015);
      final len = 100.0 * frondScale;
      canvas.save();
      canvas.translate(trunkTop.dx, trunkTop.dy);
      canvas.rotate(angle);

      // Frond stem
      final fStem = Paint()
        ..color = const Color(0xFF65A30D)
        ..strokeWidth = 3.0 * frondScale;
      canvas.drawLine(Offset.zero, Offset(len, 0), fStem);

      // Feathered pinnate leaflets
      final leafP = Paint()..color = (i % 2 == 0) ? const Color(0xFF15803D) : const Color(0xFF22C55E);
      for (double lx = 15; lx < len; lx += 10 * frondScale) {
        final pinLen = (lx < len * 0.6 ? lx * 0.5 : (len - lx) * 0.8) * frondScale;
        canvas.drawLine(Offset(lx, 0), Offset(lx + 4, pinLen), leafP..strokeWidth = 2.2 * frondScale);
        canvas.drawLine(Offset(lx, 0), Offset(lx + 4, -pinLen), leafP..strokeWidth = 2.2 * frondScale);
      }
      canvas.restore();
    }

    // Coconut cluster under crown
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(148, 92),
        Offset(166, 96),
        Offset(184, 92),
        Offset(156, 108),
        Offset(174, 108),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSingleCoconut(canvas, positions[i]);
      }
    }
  }

  // ==========================================
  // 4. POHON PEPAYA (PAPAYA TREE) BOTANY
  // ==========================================
  void _drawPapayaPlant(Canvas canvas, Offset center, double t, double sway) {
    final trunkHeight = 130.0 * (0.35 + (t * 0.65));
    final trunkTop = Offset(center.dx + (sway * 0.4), center.dy - trunkHeight);

    // Slender single trunk with diamond leaf scars
    final trunkPath = Path()
      ..moveTo(center.dx - 14, center.dy)
      ..cubicTo(center.dx - 10, center.dy - trunkHeight * 0.5, trunkTop.dx - 9, trunkTop.dy + 15, trunkTop.dx - 8, trunkTop.dy)
      ..lineTo(trunkTop.dx + 8, trunkTop.dy)
      ..cubicTo(trunkTop.dx + 9, trunkTop.dy + 15, center.dx + 10, center.dy - trunkHeight * 0.5, center.dx + 14, center.dy)
      ..close();

    final trunkPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [Color(0xFF65A30D), Color(0xFF84CC16), Color(0xFF4D7C0F)],
      ).createShader(Rect.fromLTWH(center.dx - 15, trunkTop.dy, 30, trunkHeight));
    canvas.drawPath(trunkPath, trunkPaint);

    // Large deeply-lobed palmate umbrella leaves radiating from apex
    final leafScale = 0.35 + (t * 0.65);
    final angles = [-2.7, -2.1, -1.5, -0.9, -0.3];
    for (final ang in angles) {
      canvas.save();
      canvas.translate(trunkTop.dx, trunkTop.dy);
      canvas.rotate(ang + (sway * 0.015));

      final pStem = Paint()
        ..color = const Color(0xFFA3E635)
        ..strokeWidth = 3.0 * leafScale;
      canvas.drawLine(Offset.zero, Offset(55 * leafScale, 0), pStem);

      // Deeply lobed palmate star leaf blade
      final lCenter = Offset(65 * leafScale, 0);
      final leafPaint = Paint()..color = const Color(0xFF15803D);
      for (int l = -2; l <= 2; l++) {
        final lobeAngle = l * 0.38;
        final lobeLen = 32.0 * leafScale;
        final lx = lCenter.dx + math.cos(lobeAngle) * lobeLen;
        final ly = lCenter.dy + math.sin(lobeAngle) * lobeLen;
        canvas.drawOval(
          Rect.fromCenter(center: Offset((lCenter.dx + lx) / 2, (lCenter.dy + ly) / 2), width: 14 * leafScale, height: lobeLen),
          leafPaint,
        );
      }
      canvas.restore();
    }

    // Papaya fruits clinging along upper trunk beneath leaf crown
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(155, 102),
        Offset(175, 106),
        Offset(152, 126),
        Offset(178, 130),
        Offset(165, 146),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSinglePapaya(canvas, positions[i]);
      }
    }
  }

  // ==========================================
  // 5. KEBUN SEMANGKA & MELON (GROUND VINE) BOTANY
  // ==========================================
  void _drawMelonVinePlant(Canvas canvas, Offset center, double t, double sway) {
    final vineScale = 0.3 + (t * 0.7);

    // Creeping curly vine stems spreading wide across pot and overflowing edges
    final vinePaint = Paint()
      ..color = const Color(0xFF4D7C0F)
      ..strokeWidth = 5.0 * vineScale
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final vinePath = Path()
      ..moveTo(center.dx, center.dy - 4)
      ..cubicTo(center.dx - 35, center.dy - 12, center.dx - 65, center.dy + 8, center.dx - 85, center.dy + 4)
      ..moveTo(center.dx, center.dy - 4)
      ..cubicTo(center.dx + 35, center.dy - 14, center.dx + 70, center.dy + 10, center.dx + 90, center.dy + 5)
      ..moveTo(center.dx - 20, center.dy - 8)
      ..cubicTo(center.dx - 10, center.dy - 35, center.dx + 25, center.dy - 38, center.dx + 35, center.dy - 20);
    canvas.drawPath(vinePath, vinePaint);

    // Deeply lobed rough melon/watermelon leaves
    final leafPaint = Paint()..color = const Color(0xFF16A34A);
    final leafPositions = [
      Offset(center.dx - 55, center.dy - 15),
      Offset(center.dx - 25, center.dy - 25),
      Offset(center.dx + 15, center.dy - 28),
      Offset(center.dx + 55, center.dy - 18),
      Offset(center.dx - 75, center.dy + 2),
      Offset(center.dx + 75, center.dy + 2),
      Offset(center.dx, center.dy - 16),
    ];
    for (final lp in leafPositions) {
      canvas.drawOval(
        Rect.fromCenter(center: lp, width: 26 * vineScale, height: 20 * vineScale),
        leafPaint,
      );
      // Tendrils / sulur spiral
      final tendril = Path()
        ..moveTo(lp.dx, lp.dy)
        ..cubicTo(lp.dx + 8, lp.dy - 10, lp.dx + 14, lp.dy - 4, lp.dx + 10, lp.dy - 14);
      canvas.drawPath(tendril, Paint()..color = const Color(0xFF84CC16)..strokeWidth = 1.8..style = PaintingStyle.stroke);
    }

    // Yellow melon blossoms
    if (stage == TreeGrowthStage.blooming) {
      final flowerPos = [
        Offset(center.dx - 40, center.dy - 20),
        Offset(center.dx + 35, center.dy - 24),
        Offset(center.dx, center.dy - 32),
      ];
      for (final fp in flowerPos) {
        canvas.drawCircle(fp, 6 * vineScale, Paint()..color = const Color(0xFFFACC15));
        canvas.drawCircle(fp, 3 * vineScale, Paint()..color = const Color(0xFFEA580C));
      }
    }

    // Ripe Melons / Watermelons resting on soil/vines
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(102, 192),
        Offset(138, 188),
        Offset(165, 202),
        Offset(196, 188),
        Offset(228, 194),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        if (tree.id == 'watermelon') {
          _drawSingleWatermelon(canvas, positions[i]);
        } else {
          _drawSingleMelon(canvas, positions[i]);
        }
      }
    }
  }

  // ==========================================
  // 6. KEBUN NANAS (PINEAPPLE BROMELIAD) BOTANY
  // ==========================================
  void _drawPineapplePlant(Canvas canvas, Offset center, double t, double sway) {
    final scale = 0.3 + (t * 0.7);

    // Dense rosette of sword-shaped spiky leaves radiating upwards and outwards
    canvas.save();
    canvas.translate(center.dx + (sway * 0.4), center.dy);
    canvas.scale(scale);

    final leafAngles = [-2.8, -2.4, -2.0, -1.6, -1.2, -0.8, -0.4, 0.0];
    for (int i = 0; i < leafAngles.length; i++) {
      canvas.save();
      canvas.rotate(leafAngles[i] * 0.85);

      final swordPath = Path()
        ..moveTo(0, 0)
        ..lineTo(-7, -55)
        ..lineTo(0, -78) // sharp spiky tip
        ..lineTo(7, -55)
        ..close();

      final swordPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFF14532D),
            (i % 2 == 0) ? const Color(0xFF16A34A) : const Color(0xFF4ADE80),
            const Color(0xFF86EFAC),
          ],
        ).createShader(const Rect.fromLTWH(-8, -80, 16, 80));
      canvas.drawPath(swordPath, swordPaint);
      canvas.restore();
    }
    canvas.restore();

    // Golden pinecone fruit emerging in center
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(165, 142),
        Offset(132, 168),
        Offset(198, 168),
        Offset(146, 186),
        Offset(184, 186),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSinglePineapple(canvas, positions[i], i == 0 ? 1.25 : 0.9);
      }
    }
  }

  // ==========================================
  // 7. KEBUN JAGUNG (CORN STALK) BOTANY
  // ==========================================
  void _drawCornStalkPlant(Canvas canvas, Offset center, double t, double sway) {
    final stalkHeight = 140.0 * (0.35 + (t * 0.65));
    final stalkTop = Offset(center.dx + (sway * 0.6), center.dy - stalkHeight);

    // Sturdy ribbed corn stalk
    final stalkPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [Color(0xFF4D7C0F), Color(0xFF84CC16), Color(0xFF65A30D)],
      ).createShader(Rect.fromLTWH(center.dx - 12, stalkTop.dy, 24, stalkHeight))
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, stalkTop, stalkPaint);

    // Stalk nodes (buku batang)
    final nodePaint = Paint()
      ..color = const Color(0xFF3F6212)
      ..strokeWidth = 2.5;
    for (double prog = 0.2; prog < 0.9; prog += 0.2) {
      final y = center.dy - (stalkHeight * prog);
      canvas.drawLine(Offset(center.dx - 8, y), Offset(center.dx + 8, y), nodePaint);
    }

    // Long arching ribbon-like corn leaves
    final leafScale = 0.35 + (t * 0.65);
    final leafData = [
      {'y': 0.25, 'side': -1, 'len': 75.0, 'curve': 25.0},
      {'y': 0.45, 'side': 1, 'len': 80.0, 'curve': -28.0},
      {'y': 0.65, 'side': -1, 'len': 70.0, 'curve': 32.0},
      {'y': 0.85, 'side': 1, 'len': 65.0, 'curve': -30.0},
    ];

    for (final ld in leafData) {
      final y = center.dy - (stalkHeight * (ld['y'] as double));
      final side = ld['side'] as int;
      final len = (ld['len'] as double) * leafScale;
      final curve = (ld['curve'] as double) * leafScale;

      final leafPath = Path()
        ..moveTo(center.dx, y)
        ..cubicTo(center.dx + (side * len * 0.5), y - 10, center.dx + (side * len), y + curve, center.dx + (side * len * 1.1), y + curve + 15)
        ..cubicTo(center.dx + (side * len * 0.7), y + curve - 5, center.dx + (side * len * 0.3), y + 6, center.dx, y + 4)
        ..close();

      final leafPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF84CC16), Color(0xFF4D7C0F)],
        ).createShader(Rect.fromLTWH(center.dx - len, y - 20, len * 2, 60));
      canvas.drawPath(leafPath, leafPaint);
    }

    // Feathery Golden Tassel on top (Malai bunga jagung)
    final tasselP = Paint()
      ..color = const Color(0xFFFDE047)
      ..strokeWidth = 2.0;
    for (int ti = -3; ti <= 3; ti++) {
      canvas.drawLine(stalkTop, stalkTop + Offset(ti * 7.0, -22), tasselP);
    }

    // Golden corn cobs wrapped in green husks with silk
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(140, 110),
        Offset(190, 118),
        Offset(136, 148),
        Offset(194, 154),
        Offset(165, 178),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSingleCornCob(canvas, positions[i], i % 2 == 0 ? -0.25 : 0.25);
      }
    }
  }

  // ==========================================
  // 8. POHON ANGGUR (GRAPE PERGOLA VINE) BOTANY
  // ==========================================
  void _drawGrapePergolaPlant(Canvas canvas, Offset center, double t, double sway) {
    final scale = 0.3 + (t * 0.7);

    // Rustic wooden pergola / trellis arbor
    final woodPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..strokeWidth = 8.0 * scale
      ..strokeCap = StrokeCap.round;

    // Left post, right post, crossbeam top
    canvas.drawLine(Offset(center.dx - 70 * scale, center.dy), Offset(center.dx - 70 * scale, center.dy - 120 * scale), woodPaint);
    canvas.drawLine(Offset(center.dx + 70 * scale, center.dy), Offset(center.dx + 70 * scale, center.dy - 120 * scale), woodPaint);
    canvas.drawLine(Offset(center.dx - 85 * scale, center.dy - 120 * scale), Offset(center.dx + 85 * scale, center.dy - 120 * scale), woodPaint..strokeWidth = 10.0 * scale);

    // Twining woody grape vines wrapping around posts and crossbeam
    final vineP = Paint()
      ..color = const Color(0xFF3F6212)
      ..strokeWidth = 4.0 * scale
      ..style = PaintingStyle.stroke;
    final vinePath = Path()
      ..moveTo(center.dx - 65 * scale, center.dy)
      ..cubicTo(center.dx - 75 * scale, center.dy - 60 * scale, center.dx - 60 * scale, center.dy - 80 * scale, center.dx - 70 * scale, center.dy - 120 * scale)
      ..lineTo(center.dx + 70 * scale, center.dy - 120 * scale);
    canvas.drawPath(vinePath, vineP);

    // Large lobed grape leaves (maple-like)
    final leafP = Paint()..color = const Color(0xFF16A34A);
    final leafPositions = [
      Offset(center.dx - 60 * scale, center.dy - 125 * scale),
      Offset(center.dx - 20 * scale, center.dy - 130 * scale),
      Offset(center.dx + 25 * scale, center.dy - 128 * scale),
      Offset(center.dx + 65 * scale, center.dy - 122 * scale),
      Offset(center.dx, center.dy - 134 * scale),
    ];
    for (final lp in leafPositions) {
      canvas.drawCircle(lp, 18 * scale, leafP);
      canvas.drawCircle(lp + Offset(-10 * scale, 5 * scale), 14 * scale, leafP);
      canvas.drawCircle(lp + Offset(10 * scale, 5 * scale), 14 * scale, leafP);
    }

    // Hanging pyramidal clusters of purple grapes
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(118, 112),
        Offset(150, 106),
        Offset(180, 106),
        Offset(212, 112),
        Offset(165, 132),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSingleGrapeCluster(canvas, positions[i]);
      }
    }
  }

  // ==========================================
  // 9. BUAH NAGA (DRAGONFRUIT CACTUS) BOTANY
  // ==========================================
  void _drawDragonfruitCactusPlant(Canvas canvas, Offset center, double t, double sway) {
    final scale = 0.3 + (t * 0.7);

    // Central support post
    final postPaint = Paint()
      ..color = const Color(0xFF5A3825)
      ..strokeWidth = 14.0 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, Offset(center.dx, center.dy - 100 * scale), postPaint);

    // Drooping fleshy triangular cactus ribs cascading downwards like a fountain
    final cactusPaint = Paint()
      ..color = const Color(0xFF15803D)
      ..strokeWidth = 10.0 * scale
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cactusBranches = [
      Path()..moveTo(center.dx, center.dy - 95 * scale)..cubicTo(center.dx - 45 * scale, center.dy - 110 * scale, center.dx - 70 * scale, center.dy - 60 * scale, center.dx - 80 * scale, center.dy - 15 * scale),
      Path()..moveTo(center.dx, center.dy - 95 * scale)..cubicTo(center.dx + 45 * scale, center.dy - 110 * scale, center.dx + 70 * scale, center.dy - 60 * scale, center.dx + 80 * scale, center.dy - 15 * scale),
      Path()..moveTo(center.dx, center.dy - 95 * scale)..cubicTo(center.dx - 25 * scale, center.dy - 100 * scale, center.dx - 40 * scale, center.dy - 40 * scale, center.dx - 45 * scale, center.dy + 5 * scale),
      Path()..moveTo(center.dx, center.dy - 95 * scale)..cubicTo(center.dx + 25 * scale, center.dy - 100 * scale, center.dx + 40 * scale, center.dy - 40 * scale, center.dx + 45 * scale, center.dy + 5 * scale),
    ];
    for (final bp in cactusBranches) {
      canvas.drawPath(bp, cactusPaint);
    }

    // Dragonfruit fruits with exotic magenta scales on cactus ribs
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(114, 126),
        Offset(216, 126),
        Offset(138, 96),
        Offset(192, 96),
        Offset(165, 120),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSingleDragonfruit(canvas, positions[i]);
      }
    }
  }

  // ==========================================
  // 10. POHON TOMAT (TOMATO BUSH) BOTANY
  // ==========================================
  void _drawTomatoBushPlant(Canvas canvas, Offset center, double t, double sway) {
    final scale = 0.3 + (t * 0.7);

    // Bamboo garden stake support
    final stakeP = Paint()
      ..color = const Color(0xFFCA8A04)
      ..strokeWidth = 6.0 * scale;
    canvas.drawLine(center, Offset(center.dx, center.dy - 130 * scale), stakeP);

    // Multi-branching fuzzy green tomato vines
    final vineP = Paint()
      ..color = const Color(0xFF4D7C0F)
      ..strokeWidth = 5.0 * scale
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final vPath = Path()
      ..moveTo(center.dx, center.dy)
      ..cubicTo(center.dx - 25 * scale, center.dy - 50 * scale, center.dx - 55 * scale, center.dy - 80 * scale, center.dx - 45 * scale, center.dy - 115 * scale)
      ..moveTo(center.dx, center.dy)
      ..cubicTo(center.dx + 25 * scale, center.dy - 50 * scale, center.dx + 55 * scale, center.dy - 80 * scale, center.dx + 45 * scale, center.dy - 115 * scale);
    canvas.drawPath(vPath, vineP);

    // Serrated pinnate tomato foliage
    final leafP = Paint()..color = const Color(0xFF16A34A);
    final leafNodes = [
      Offset(center.dx - 45 * scale, center.dy - 60 * scale),
      Offset(center.dx + 45 * scale, center.dy - 60 * scale),
      Offset(center.dx - 30 * scale, center.dy - 95 * scale),
      Offset(center.dx + 30 * scale, center.dy - 95 * scale),
      Offset(center.dx, center.dy - 120 * scale),
    ];
    for (final ln in leafNodes) {
      canvas.drawOval(Rect.fromCenter(center: ln, width: 26 * scale, height: 16 * scale), leafP);
      canvas.drawOval(Rect.fromCenter(center: ln + Offset(-8 * scale, -6 * scale), width: 14 * scale, height: 10 * scale), leafP);
      canvas.drawOval(Rect.fromCenter(center: ln + Offset(8 * scale, -6 * scale), width: 14 * scale, height: 10 * scale), leafP);
    }

    // Bright red glossy tomatoes with star calyx caps
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(124, 138),
        Offset(206, 138),
        Offset(140, 102),
        Offset(190, 102),
        Offset(165, 78),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSingleTomato(canvas, positions[i]);
      }
    }
  }

  // ==========================================
  // 11. KEBUN BLUBERI (BLUEBERRY SHRUB) BOTANY
  // ==========================================
  void _drawBlueberryBushPlant(Canvas canvas, Offset center, double t, double sway) {
    final scale = 0.3 + (t * 0.7);

    // Multi-stem woody shrub crown
    final stemP = Paint()
      ..color = const Color(0xFF5A3825)
      ..strokeWidth = 4.0 * scale
      ..strokeCap = StrokeCap.round;
    for (double ang = -0.55; ang <= 0.55; ang += 0.28) {
      final endX = center.dx + math.sin(ang) * 90 * scale;
      final endY = center.dy - math.cos(ang) * 90 * scale;
      canvas.drawLine(center, Offset(endX, endY), stemP);
    }

    // Dense oval leaves with blue-green glaze
    final leafP = Paint()..color = const Color(0xFF0D9488);
    final lPositions = [
      Offset(center.dx - 55 * scale, center.dy - 65 * scale),
      Offset(center.dx - 25 * scale, center.dy - 90 * scale),
      Offset(center.dx + 25 * scale, center.dy - 90 * scale),
      Offset(center.dx + 55 * scale, center.dy - 65 * scale),
      Offset(center.dx, center.dy - 75 * scale),
    ];
    for (final lp in lPositions) {
      canvas.drawCircle(lp, 22 * scale, leafP);
      canvas.drawCircle(lp + Offset(-12 * scale, 6 * scale), 16 * scale, Paint()..color = const Color(0xFF14B8A6));
    }

    // Deep indigo blueberries with star-shaped crown calyx
    if (stage == TreeGrowthStage.harvest || stage == TreeGrowthStage.completed) {
      final positions = const [
        Offset(120, 132),
        Offset(210, 130),
        Offset(142, 98),
        Offset(188, 98),
        Offset(165, 122),
      ];
      for (int i = 0; i < positions.length; i++) {
        if (harvestedFruits.contains(i)) continue;
        _drawSingleBlueberry(canvas, positions[i]);
      }
    }
  }

  // ==========================================
  // 12. POHON APEL & ORCHARD CANOPY BOTANY
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

    // 4. Ripe 3D Fruits with Authentic Botanical Geometry
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

      switch (tree.id) {
        case 'apple':
          _drawSingleApple(canvas, fruitCenter);
          break;
        case 'orange':
          _drawSingleOrange(canvas, fruitCenter);
          break;
        case 'mango':
          _drawSingleMango(canvas, fruitCenter);
          break;
        case 'avocado':
          _drawSingleAvocado(canvas, fruitCenter);
          break;
        case 'peach':
          _drawSinglePeach(canvas, fruitCenter);
          break;
        case 'pear':
          _drawSinglePear(canvas, fruitCenter);
          break;
        case 'lemon':
          _drawSingleLemon(canvas, fruitCenter);
          break;
        case 'cherry':
          _drawSingleCherry(canvas, fruitCenter);
          break;
        case 'kiwi':
          _drawSingleKiwi(canvas, fruitCenter);
          break;
        case 'starfruit':
          _drawSingleStarfruit(canvas, fruitCenter);
          break;
        default:
          _drawSingleApple(canvas, fruitCenter);
          break;
      }
    }
  }

  // =========================================================================
  // DEDICATED 3D VECTOR FRUIT RENDERERS (NO EMOJIS, PURE AUTHENTIC ANATOMY)
  // =========================================================================

  void _drawSingleApple(Canvas canvas, Offset fruitCenter) {
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

    final orangePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        radius: 0.85,
        colors: [Color(0xFFFDBA74), Color(0xFFEA580C), Color(0xFF9A3412)],
        stops: [0.0, 0.65, 1.0],
      ).createShader(fruitRect);
    canvas.drawCircle(fruitCenter, radius, orangePaint);

    // Citrus Pores
    final porePaint = Paint()..color = const Color(0xFFC2410C).withValues(alpha: 0.35);
    canvas.drawCircle(fruitCenter + const Offset(-4, 3), 1.0, porePaint);
    canvas.drawCircle(fruitCenter + const Offset(5, -2), 1.0, porePaint);
    canvas.drawCircle(fruitCenter + const Offset(2, 6), 1.0, porePaint);

    // Specular Glaze
    canvas.drawOval(
      Rect.fromCenter(center: fruitCenter - const Offset(5, 5), width: 8, height: 5),
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );

    // Button Calyx & Leaf
    final calyxPaint = Paint()..color = const Color(0xFF15803D);
    canvas.drawCircle(fruitCenter - const Offset(0, radius - 2), 2.2, calyxPaint);
    final leaf = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - radius)
      ..cubicTo(fruitCenter.dx + 7, fruitCenter.dy - radius - 6, fruitCenter.dx + 9, fruitCenter.dy - radius, fruitCenter.dx, fruitCenter.dy - radius + 1)
      ..close();
    canvas.drawPath(leaf, Paint()..color = const Color(0xFF22C55E));
  }

  void _drawSingleMango(Canvas canvas, Offset fruitCenter) {
    // Characteristic asymmetrical kidney/teardrop mango shape
    final mangoPath = Path()
      ..moveTo(fruitCenter.dx - 2, fruitCenter.dy - 18)
      ..cubicTo(fruitCenter.dx + 16, fruitCenter.dy - 14, fruitCenter.dx + 22, fruitCenter.dy + 8, fruitCenter.dx + 12, fruitCenter.dy + 18)
      ..cubicTo(fruitCenter.dx + 2, fruitCenter.dy + 24, fruitCenter.dx - 12, fruitCenter.dy + 20, fruitCenter.dx - 16, fruitCenter.dy + 10)
      ..cubicTo(fruitCenter.dx - 20, fruitCenter.dy - 6, fruitCenter.dx - 14, fruitCenter.dy - 18, fruitCenter.dx - 2, fruitCenter.dy - 18)
      ..close();

    final mRect = Rect.fromCenter(center: fruitCenter, width: 42, height: 44);
    final mangoPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.85,
        colors: [Color(0xFFFEF08A), Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF84CC16)],
        stops: [0.0, 0.45, 0.85, 1.0],
      ).createShader(mRect);
    canvas.drawPath(mangoPath, mangoPaint);

    // Mango highlight
    canvas.drawOval(
      Rect.fromCenter(center: fruitCenter - const Offset(5, 5), width: 10, height: 6),
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );

    // Stem
    canvas.drawLine(fruitCenter - const Offset(2, 18), fruitCenter - const Offset(4, 25), Paint()..color = const Color(0xFF78350F)..strokeWidth = 2.2);
  }

  void _drawSingleAvocado(Canvas canvas, Offset fruitCenter) {
    // Pear-shaped dark green bumpy avocado
    final avoPath = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - 18)
      ..cubicTo(fruitCenter.dx + 10, fruitCenter.dy - 14, fruitCenter.dx + 18, fruitCenter.dy + 4, fruitCenter.dx + 14, fruitCenter.dy + 16)
      ..cubicTo(fruitCenter.dx + 8, fruitCenter.dy + 22, fruitCenter.dx - 8, fruitCenter.dy + 22, fruitCenter.dx - 14, fruitCenter.dy + 16)
      ..cubicTo(fruitCenter.dx - 18, fruitCenter.dy + 4, fruitCenter.dx - 10, fruitCenter.dy - 14, fruitCenter.dx, fruitCenter.dy - 18)
      ..close();

    final avoRect = Rect.fromCenter(center: fruitCenter, width: 38, height: 42);
    final avoPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        radius: 0.85,
        colors: [Color(0xFF84CC16), Color(0xFF15803D), Color(0xFF14532D), Color(0xFF052E16)],
        stops: [0.0, 0.45, 0.8, 1.0],
      ).createShader(avoRect);
    canvas.drawPath(avoPath, avoPaint);

    // Highlight
    canvas.drawOval(
      Rect.fromCenter(center: fruitCenter - const Offset(4, 5), width: 8, height: 5),
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );
    canvas.drawLine(fruitCenter - const Offset(0, 18), fruitCenter - const Offset(0, 24), Paint()..color = const Color(0xFF78350F)..strokeWidth = 2.4);
  }

  void _drawSinglePeach(Canvas canvas, Offset fruitCenter) {
    // Round velvety peach with characteristic cleft groove
    final peachRect = Rect.fromCircle(center: fruitCenter, radius: 18);
    final peachPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        radius: 0.85,
        colors: [Color(0xFFFDE047), Color(0xFFF472B6), Color(0xFFE11D48), Color(0xFF9F1239)],
        stops: [0.0, 0.4, 0.8, 1.0],
      ).createShader(peachRect);
    canvas.drawCircle(fruitCenter, 18, peachPaint);

    // Peach indentation cleft
    final cleftPath = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - 18)
      ..cubicTo(fruitCenter.dx - 3, fruitCenter.dy - 6, fruitCenter.dx - 2, fruitCenter.dy + 8, fruitCenter.dx, fruitCenter.dy + 18);
    canvas.drawPath(
      cleftPath,
      Paint()..color = const Color(0xFFBE123C).withValues(alpha: 0.5)..strokeWidth = 2.0..style = PaintingStyle.stroke,
    );

    // Stem and pointed leaf
    canvas.drawLine(fruitCenter - const Offset(0, 18), fruitCenter - const Offset(2, 25), Paint()..color = const Color(0xFF78350F)..strokeWidth = 2.0);
    final lPath = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - 20)
      ..cubicTo(fruitCenter.dx + 8, fruitCenter.dy - 26, fruitCenter.dx + 12, fruitCenter.dy - 20, fruitCenter.dx, fruitCenter.dy - 20);
    canvas.drawPath(lPath, Paint()..color = const Color(0xFF4ADE80));
  }

  void _drawSinglePear(Canvas canvas, Offset fruitCenter) {
    // Distinct Pyriform (bell-like) pear shape
    final pearPath = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - 18)
      ..cubicTo(fruitCenter.dx + 8, fruitCenter.dy - 12, fruitCenter.dx + 10, fruitCenter.dy - 2, fruitCenter.dx + 18, fruitCenter.dy + 10)
      ..cubicTo(fruitCenter.dx + 20, fruitCenter.dy + 22, fruitCenter.dx - 20, fruitCenter.dy + 22, fruitCenter.dx - 18, fruitCenter.dy + 10)
      ..cubicTo(fruitCenter.dx - 10, fruitCenter.dy - 2, fruitCenter.dx - 8, fruitCenter.dy - 12, fruitCenter.dx, fruitCenter.dy - 18)
      ..close();

    final pearRect = Rect.fromCenter(center: fruitCenter, width: 42, height: 44);
    final pearPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        radius: 0.85,
        colors: [Color(0xFFFEF08A), Color(0xFFA3E635), Color(0xFF65A30D), Color(0xFF3F6212)],
        stops: [0.0, 0.45, 0.8, 1.0],
      ).createShader(pearRect);
    canvas.drawPath(pearPath, pearPaint);

    // Pear highlight
    canvas.drawOval(
      Rect.fromCenter(center: fruitCenter - const Offset(5, 4), width: 9, height: 6),
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );
    // Curving wood stem
    final sPath = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - 18)
      ..cubicTo(fruitCenter.dx + 3, fruitCenter.dy - 24, fruitCenter.dx + 6, fruitCenter.dy - 26, fruitCenter.dx + 8, fruitCenter.dy - 28);
    canvas.drawPath(sPath, Paint()..color = const Color(0xFF78350F)..strokeWidth = 2.4..style = PaintingStyle.stroke);
  }

  void _drawSingleLemon(Canvas canvas, Offset fruitCenter) {
    // Elliptical citrus with pointed mammilla / nipple ends
    final lemonPath = Path()
      ..moveTo(fruitCenter.dx, fruitCenter.dy - 20) // top nipple
      ..cubicTo(fruitCenter.dx + 16, fruitCenter.dy - 12, fruitCenter.dx + 18, fruitCenter.dy + 12, fruitCenter.dx, fruitCenter.dy + 20) // bottom nipple
      ..cubicTo(fruitCenter.dx - 18, fruitCenter.dy + 12, fruitCenter.dx - 16, fruitCenter.dy - 12, fruitCenter.dx, fruitCenter.dy - 20)
      ..close();

    final lRect = Rect.fromCenter(center: fruitCenter, width: 38, height: 44);
    final lemonPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        radius: 0.85,
        colors: [Color(0xFFFEF08A), Color(0xFFFACC15), Color(0xFFCA8A04)],
        stops: [0.0, 0.6, 1.0],
      ).createShader(lRect);
    canvas.drawPath(lemonPath, lemonPaint);

    // Specular shine
    canvas.drawOval(
      Rect.fromCenter(center: fruitCenter - const Offset(5, 5), width: 9, height: 6),
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
    // Little green stem and leaf
    canvas.drawLine(fruitCenter - const Offset(0, 20), fruitCenter - const Offset(0, 26), Paint()..color = const Color(0xFF65A30D)..strokeWidth = 2.2);
  }

  void _drawSingleCherry(Canvas canvas, Offset fruitCenter) {
    // Twin pair of deep crimson cherries with long curving green stems
    final c1 = fruitCenter + const Offset(-7, 4);
    final c2 = fruitCenter + const Offset(8, 2);

    final cherryPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        colors: [Color(0xFFFDA4AF), Color(0xFFE11D48), Color(0xFF881337)],
      ).createShader(Rect.fromCircle(center: c1, radius: 11));

    canvas.drawCircle(c1, 10.5, cherryPaint);
    canvas.drawCircle(c2, 10.0, cherryPaint);

    // Highlights
    canvas.drawOval(Rect.fromCenter(center: c1 - const Offset(3, 3), width: 5, height: 3), Paint()..color = Colors.white.withValues(alpha: 0.75));
    canvas.drawOval(Rect.fromCenter(center: c2 - const Offset(3, 3), width: 5, height: 3), Paint()..color = Colors.white.withValues(alpha: 0.75));

    // Curving long stems meeting at top junction
    final apex = fruitCenter - const Offset(0, 22);
    final stemP = Paint()..color = const Color(0xFF4ADE80)..strokeWidth = 2.0..style = PaintingStyle.stroke;
    final s1 = Path()..moveTo(c1.dx, c1.dy - 9)..cubicTo(c1.dx - 4, apex.dy + 8, apex.dx - 2, apex.dy + 2, apex.dx, apex.dy);
    final s2 = Path()..moveTo(c2.dx, c2.dy - 9)..cubicTo(c2.dx + 4, apex.dy + 8, apex.dx + 2, apex.dy + 2, apex.dx, apex.dy);
    canvas.drawPath(s1, stemP);
    canvas.drawPath(s2, stemP);
  }

  void _drawSingleKiwi(Canvas canvas, Offset fruitCenter) {
    // Fuzzy brown oval fruit
    final kRect = Rect.fromCenter(center: fruitCenter, width: 34, height: 28);
    final kiwiPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFFA16207), Color(0xFF78350F), Color(0xFF451A03)],
      ).createShader(kRect);
    canvas.drawOval(kRect, kiwiPaint);

    // Fuzzy bristles texture
    final fuzzP = Paint()..color = const Color(0xFFD97706).withValues(alpha: 0.5)..strokeWidth = 1.0;
    for (int i = 0; i < 8; i++) {
      final ang = i * 0.8;
      canvas.drawLine(
        fruitCenter + Offset(math.cos(ang) * 16, math.sin(ang) * 13),
        fruitCenter + Offset(math.cos(ang) * 19, math.sin(ang) * 15),
        fuzzP,
      );
    }
    // Specular
    canvas.drawOval(Rect.fromCenter(center: fruitCenter - const Offset(4, 4), width: 7, height: 4), Paint()..color = Colors.white.withValues(alpha: 0.35));
  }

  void _drawSingleStarfruit(Canvas canvas, Offset fruitCenter) {
    // 5-pointed star ridges (Carambola)
    final sfPath = Path();
    for (int i = 0; i < 10; i++) {
      final r = (i % 2 == 0) ? 19.0 : 9.0;
      final ang = (i * math.pi / 5) - (math.pi / 2);
      final x = fruitCenter.dx + math.cos(ang) * r;
      final y = fruitCenter.dy + math.sin(ang) * r;
      if (i == 0) {
        sfPath.moveTo(x, y);
      } else {
        sfPath.lineTo(x, y);
      }
    }
    sfPath.close();

    final sfRect = Rect.fromCircle(center: fruitCenter, radius: 20);
    final sfPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.25),
        colors: [Color(0xFFFEF08A), Color(0xFFFACC15), Color(0xFF84CC16)],
        stops: [0.0, 0.65, 1.0],
      ).createShader(sfRect);
    canvas.drawPath(sfPath, sfPaint);

    // Star ridge lines
    final ridgeP = Paint()..color = const Color(0xFF65A30D)..strokeWidth = 1.5;
    for (int i = 0; i < 5; i++) {
      final ang = (i * 2 * math.pi / 5) - (math.pi / 2);
      canvas.drawLine(fruitCenter, fruitCenter + Offset(math.cos(ang) * 18, math.sin(ang) * 18), ridgeP);
    }
  }

  void _drawSingleCoconut(Canvas canvas, Offset pos) {
    final cRect = Rect.fromCircle(center: pos, radius: 15);
    final cPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        colors: [Color(0xFF854D0E), Color(0xFF5A3825), Color(0xFF291508)],
      ).createShader(cRect);
    canvas.drawCircle(pos, 15, cPaint);

    // 3 Coconut eyes (germination pores)
    final eyeP = Paint()..color = const Color(0xFF1C0E05);
    canvas.drawCircle(pos + const Offset(-4, -4), 1.8, eyeP);
    canvas.drawCircle(pos + const Offset(3, -5), 1.8, eyeP);
    canvas.drawCircle(pos + const Offset(0, 2), 1.8, eyeP);

    // Highlight
    canvas.drawOval(Rect.fromCenter(center: pos - const Offset(4, 5), width: 6, height: 4), Paint()..color = Colors.white.withValues(alpha: 0.35));
  }

  void _drawSinglePapaya(Canvas canvas, Offset pos) {
    // Oblong elongated papaya
    final pPath = Path()
      ..moveTo(pos.dx, pos.dy - 16)
      ..cubicTo(pos.dx + 12, pos.dy - 10, pos.dx + 14, pos.dy + 10, pos.dx, pos.dy + 18)
      ..cubicTo(pos.dx - 14, pos.dy + 10, pos.dx - 12, pos.dy - 10, pos.dx, pos.dy - 16)
      ..close();

    final pRect = Rect.fromCenter(center: pos, width: 30, height: 38);
    final pPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF84CC16), Color(0xFFFBBF24), Color(0xFFF97316)],
      ).createShader(pRect);
    canvas.drawPath(pPath, pPaint);

    // Highlight
    canvas.drawOval(Rect.fromCenter(center: pos - const Offset(3, 4), width: 6, height: 10), Paint()..color = Colors.white.withValues(alpha: 0.5));
  }

  void _drawSingleWatermelon(Canvas canvas, Offset pos) {
    // Large oval green watermelon with dark emerald wavy stripes
    final wmRect = Rect.fromCenter(center: pos, width: 36, height: 28);
    final wmPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFF86EFAC), Color(0xFF22C55E), Color(0xFF15803D)],
      ).createShader(wmRect);
    canvas.drawOval(wmRect, wmPaint);

    // Dark green vertical zigzag stripes
    final stripeP = Paint()..color = const Color(0xFF052E16)..strokeWidth = 2.4..style = PaintingStyle.stroke;
    for (int sx = -10; sx <= 10; sx += 7) {
      final sPath = Path()
        ..moveTo(pos.dx + sx, pos.dy - 13)
        ..cubicTo(pos.dx + sx + 3, pos.dy - 5, pos.dx + sx - 3, pos.dy + 5, pos.dx + sx, pos.dy + 13);
      canvas.drawPath(sPath, stripeP);
    }
    // Specular shine
    canvas.drawOval(Rect.fromCenter(center: pos - const Offset(5, 5), width: 8, height: 4), Paint()..color = Colors.white.withValues(alpha: 0.65));
  }

  void _drawSingleMelon(Canvas canvas, Offset pos) {
    // Round cantaloupe / honeydew melon with net lattice
    final mRect = Rect.fromCircle(center: pos, radius: 16);
    final mPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFFD9F99D), Color(0xFF84CC16), Color(0xFF4D7C0F)],
      ).createShader(mRect);
    canvas.drawCircle(pos, 16, mPaint);

    // Netting texture lines
    final netP = Paint()..color = const Color(0xFFECFCCB).withValues(alpha: 0.5)..strokeWidth = 1.2..style = PaintingStyle.stroke;
    canvas.drawCircle(pos, 11, netP);
    canvas.drawCircle(pos, 6, netP);
    canvas.drawLine(pos - const Offset(15, 0), pos + const Offset(15, 0), netP);
    canvas.drawLine(pos - const Offset(0, 15), pos + const Offset(0, 15), netP);
  }

  void _drawSinglePineapple(Canvas canvas, Offset pos, double scale) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(scale);

    // Golden pinecone body with diamond pattern
    final pRect = Rect.fromCenter(center: Offset.zero, width: 24, height: 32);
    final pPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.25),
        colors: [Color(0xFFFEF08A), Color(0xFFFBBF24), Color(0xFFD97706), Color(0xFF92400E)],
      ).createShader(pRect);
    canvas.drawRRect(RRect.fromRectAndRadius(pRect, const Radius.circular(10)), pPaint);

    // Pinecone scales diamond lines
    final sP = Paint()..color = const Color(0xFF78350F).withValues(alpha: 0.4)..strokeWidth = 1.4;
    canvas.drawLine(const Offset(-10, -8), const Offset(10, 8), sP);
    canvas.drawLine(const Offset(-10, 0), const Offset(10, 16), sP);
    canvas.drawLine(const Offset(10, -8), const Offset(-10, 8), sP);
    canvas.drawLine(const Offset(10, 0), const Offset(-10, 16), sP);

    // Spiky crown tuft on top
    final crownP = Paint()..color = const Color(0xFF16A34A);
    for (int ci = -2; ci <= 2; ci++) {
      final cPath = Path()
        ..moveTo(0, -14)
        ..lineTo(ci * 7.0, -26)
        ..lineTo(ci * 3.0, -14)
        ..close();
      canvas.drawPath(cPath, crownP);
    }
    canvas.restore();
  }

  void _drawSingleCornCob(Canvas canvas, Offset pos, double tilt) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(tilt);

    // Golden cylindrical corn ear
    final cornRect = Rect.fromCenter(center: Offset.zero, width: 18, height: 36);
    final cornPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFFEF08A), Color(0xFFFBBF24), Color(0xFFD97706)],
      ).createShader(cornRect);
    canvas.drawRRect(RRect.fromRectAndRadius(cornRect, const Radius.circular(8)), cornPaint);

    // Rows of corn kernels
    final kP = Paint()..color = const Color(0xFFB45309).withValues(alpha: 0.4)..strokeWidth = 1.0;
    for (double y = -14; y <= 14; y += 5) {
      canvas.drawLine(Offset(-8, y), Offset(8, y), kP);
    }

    // Green husk wrapping bottom
    final huskP = Paint()..color = const Color(0xFF65A30D);
    final h1 = Path()..moveTo(-9, 18)..cubicTo(-14, 0, -10, -10, -5, -4)..lineTo(-9, 18);
    final h2 = Path()..moveTo(9, 18)..cubicTo(14, 0, 10, -10, 5, -4)..lineTo(9, 18);
    canvas.drawPath(h1, huskP);
    canvas.drawPath(h2, huskP);

    // Brown silk tassel on tip
    final silkP = Paint()..color = const Color(0xFF92400E)..strokeWidth = 1.2;
    canvas.drawLine(const Offset(0, -18), const Offset(-3, -25), silkP);
    canvas.drawLine(const Offset(0, -18), const Offset(2, -26), silkP);

    canvas.restore();
  }

  void _drawSingleGrapeCluster(Canvas canvas, Offset pos) {
    // Authentic conical cluster of glossy purple spheres
    final gPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        colors: const [Color(0xFFC084FC), Color(0xFF8B5CF6), Color(0xFF581C87)],
      ).createShader(Rect.fromCircle(center: pos, radius: 18));

    // Top row (3 berries)
    canvas.drawCircle(pos + const Offset(-8, -8), 6.5, gPaint);
    canvas.drawCircle(pos + const Offset(0, -9), 6.5, gPaint);
    canvas.drawCircle(pos + const Offset(8, -8), 6.5, gPaint);

    // Middle row (2 berries)
    canvas.drawCircle(pos + const Offset(-4, 0), 6.5, gPaint);
    canvas.drawCircle(pos + const Offset(4, 0), 6.5, gPaint);

    // Bottom single tip berry
    canvas.drawCircle(pos + const Offset(0, 9), 6.5, gPaint);

    // Stem hook
    canvas.drawLine(pos - const Offset(0, 12), pos - const Offset(0, 18), Paint()..color = const Color(0xFF65A30D)..strokeWidth = 2.0);
  }

  void _drawSingleDragonfruit(Canvas canvas, Offset pos) {
    // Magenta oval fruit with green leafy bracts
    final dfRect = Rect.fromCenter(center: pos, width: 28, height: 36);
    final dfPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFFF472B6), Color(0xFFD946EF), Color(0xFF86198F)],
      ).createShader(dfRect);
    canvas.drawOval(dfRect, dfPaint);

    // Green scales / bracts on outer surface
    final scaleP = Paint()..color = const Color(0xFF4ADE80);
    final scales = [
      Offset(pos.dx - 12, pos.dy - 6),
      Offset(pos.dx + 12, pos.dy - 6),
      Offset(pos.dx - 10, pos.dy + 8),
      Offset(pos.dx + 10, pos.dy + 8),
      Offset(pos.dx, pos.dy - 17),
    ];
    for (final s in scales) {
      final sPath = Path()
        ..moveTo(s.dx, s.dy)
        ..lineTo(s.dx + (s.dx < pos.dx ? -5 : 5), s.dy - 4)
        ..lineTo(s.dx, s.dy - 6)
        ..close();
      canvas.drawPath(sPath, scaleP);
    }
  }

  void _drawSingleTomato(Canvas canvas, Offset pos) {
    // Glossy bright red round tomato with 5-point star green calyx
    final tRect = Rect.fromCircle(center: pos, radius: 16);
    final tPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        colors: [Color(0xFFF87171), Color(0xFFEF4444), Color(0xFF991B1B)],
      ).createShader(tRect);
    canvas.drawCircle(pos, 16, tPaint);

    // Specular Shine
    canvas.drawOval(Rect.fromCenter(center: pos - const Offset(5, 5), width: 7, height: 4), Paint()..color = Colors.white.withValues(alpha: 0.8));

    // Star green calyx
    final cP = Paint()..color = const Color(0xFF15803D);
    for (int i = 0; i < 5; i++) {
      final ang = i * 2 * math.pi / 5;
      final tip = pos - const Offset(0, 14) + Offset(math.cos(ang) * 6, math.sin(ang) * 5);
      canvas.drawLine(pos - const Offset(0, 14), tip, cP..strokeWidth = 2.0);
    }
    // Stem
    canvas.drawLine(pos - const Offset(0, 14), pos - const Offset(0, 20), Paint()..color = const Color(0xFF65A30D)..strokeWidth = 2.2);
  }

  void _drawSingleBlueberry(Canvas canvas, Offset pos) {
    // Deep indigo spherical blueberry with star calyx crown
    final bRect = Rect.fromCircle(center: pos, radius: 14);
    final bPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFF93C5FD), Color(0xFF3B82F6), Color(0xFF1E3A8A)],
      ).createShader(bRect);
    canvas.drawCircle(pos, 14, bPaint);

    // Calyx indentation crown
    final crownP = Paint()..color = const Color(0xFF172554)..style = PaintingStyle.stroke..strokeWidth = 1.4;
    canvas.drawCircle(pos, 4.5, crownP);
    for (int i = 0; i < 5; i++) {
      final ang = i * 2 * math.pi / 5;
      canvas.drawLine(pos, pos + Offset(math.cos(ang) * 6, math.sin(ang) * 6), crownP);
    }

    // Specular highlight
    canvas.drawOval(Rect.fromCenter(center: pos - const Offset(4, 4), width: 5, height: 3), Paint()..color = Colors.white.withValues(alpha: 0.7));
  }

  @override
  bool shouldRepaint(covariant _MagicalTreePainter oldDelegate) => true;
}
