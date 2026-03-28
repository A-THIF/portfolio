import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/sound_effects.dart';

// ─────────────────────────────────────────────
//  BALL MODEL
// ─────────────────────────────────────────────
class _Ball {
  double x, y, dx, dy;
  final double radius;
  final int id;

  _Ball({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
    required this.id,
  });
}

// ─────────────────────────────────────────────
//  PHASES
// ─────────────────────────────────────────────
enum _Phase {
  phase1, // 0–5s: message + 1 slow ball
  phase2, // 5–50s: balls multiplying, physics
  phase3, // 50–60s: intensity, shake, message fades
  phase4, // collapse: freeze → fall
  phase5, // emotional message
}

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────
class MobileInfoScreen extends StatefulWidget {
  final int selectedIndex;
  const MobileInfoScreen({super.key, required this.selectedIndex});

  @override
  State<MobileInfoScreen> createState() => _MobileInfoScreenState();
}

class _MobileInfoScreenState extends State<MobileInfoScreen>
    with TickerProviderStateMixin {
  // ── Physics ──────────────────────────────
  final List<_Ball> _balls = [];
  final Random _rng = Random();
  Timer? _physicsTimer;
  Timer? _spawnTimer;
  Timer? _phaseTimer;

  double _speedMult = 1.0;
  int _elapsed = 0;

  _Phase _phase = _Phase.phase1;

  // ── Shake ─────────────────────────────────
  late AnimationController _shakeCtrl;
  double _shakeX = 0;
  double _shakeY = 0;

  // ── Fall ──────────────────────────────────
  late AnimationController _fallCtrl;
  late Animation<double> _fallAnim;
  bool _frozen = false;
  final List<double> _fallMults = [];

  // ── Message fade (phase3) ─────────────────
  late AnimationController _msgFadeCtrl;
  late Animation<double> _msgOpacity;

  // ── Phase5 fade in ────────────────────────
  late AnimationController _phase5Ctrl;
  late Animation<double> _phase5Anim;

  static const double _ballR = 28.0;

  // ─────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )..addListener(() {
        setState(() {
          _shakeX = (_rng.nextDouble() - 0.5) * 10 * _shakeCtrl.value;
          _shakeY = (_rng.nextDouble() - 0.5) * 10 * _shakeCtrl.value;
        });
      });

    _fallCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fallAnim = CurvedAnimation(parent: _fallCtrl, curve: Curves.easeIn);

    _msgFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _msgOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _msgFadeCtrl, curve: Curves.easeIn),
    );

    _phase5Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _phase5Anim = CurvedAnimation(parent: _phase5Ctrl, curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) => _startExperience());
  }

  // ─────────────────────────────────────────
  //  START
  // ─────────────────────────────────────────
  void _startExperience() {
    final size = MediaQuery.of(context).size;
    _spawnBall(size, slow: true);

    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _elapsed++;

      if (_elapsed == 5 && _phase == _Phase.phase1) {
        setState(() => _phase = _Phase.phase2);
        _startSpawning(size);
      }
      if (_elapsed == 50 && _phase == _Phase.phase2) {
        setState(() => _phase = _Phase.phase3);
        _startPhase3();
      }
      if (_elapsed == 60 && _phase == _Phase.phase3) {
        _triggerCollapse();
      }

      if (_phase == _Phase.phase2 && _elapsed % 4 == 0) {
        _speedMult = (_speedMult + 0.08).clamp(1.0, 3.0);
      }
      if (_phase == _Phase.phase3 && _elapsed % 2 == 0) {
        _speedMult = (_speedMult + 0.2).clamp(1.0, 6.0);
      }
    });

    _physicsTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted) return;
      if (_phase == _Phase.phase1 ||
          _phase == _Phase.phase2 ||
          _phase == _Phase.phase3) {
        _tick();
      }
    });
  }

  // ─────────────────────────────────────────
  //  SPAWN
  // ─────────────────────────────────────────
  void _startSpawning(Size size) {
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      if (!mounted) return;
      if (_balls.length < 40 &&
          (_phase == _Phase.phase2 || _phase == _Phase.phase3)) {
        _spawnBall(size);
      }
    });
  }

  void _spawnBall(Size size, {bool slow = false}) {
    final angle = _rng.nextDouble() * 2 * pi;
    final spd = slow ? 1.2 : (2.0 + _rng.nextDouble() * 1.5);
    setState(() {
      _balls.add(_Ball(
        id: _balls.length,
        x: _ballR * 2 + _rng.nextDouble() * (size.width - _ballR * 4),
        y: _ballR * 2 + _rng.nextDouble() * (size.height * 0.4),
        dx: cos(angle) * spd,
        dy: sin(angle).abs() * spd,
        radius: _ballR,
      ));
    });
  }

  // ─────────────────────────────────────────
  //  PHYSICS TICK
  // ─────────────────────────────────────────
  void _tick() {
    if (_frozen) return;
    final size = MediaQuery.of(context).size;

    setState(() {
      for (final b in _balls) {
        b.x += b.dx * _speedMult;
        b.y += b.dy * _speedMult;

        if (b.x - b.radius <= 0) {
          b.x = b.radius;
          b.dx = b.dx.abs();
        } else if (b.x + b.radius >= size.width) {
          b.x = size.width - b.radius;
          b.dx = -b.dx.abs();
        }
        if (b.y - b.radius <= 0) {
          b.y = b.radius;
          b.dy = b.dy.abs();
        } else if (b.y + b.radius >= size.height) {
          b.y = size.height - b.radius;
          b.dy = -b.dy.abs();
        }
      }

      for (int i = 0; i < _balls.length; i++) {
        for (int j = i + 1; j < _balls.length; j++) {
          _resolveCollision(_balls[i], _balls[j]);
        }
      }
    });
  }

  void _resolveCollision(_Ball a, _Ball b) {
    final dx = b.x - a.x;
    final dy = b.y - a.y;
    final dist = sqrt(dx * dx + dy * dy);
    final minDist = a.radius + b.radius;
    if (dist < minDist && dist > 0.001) {
      final overlap = (minDist - dist) / 2;
      final nx = dx / dist;
      final ny = dy / dist;
      a.x -= nx * overlap;
      a.y -= ny * overlap;
      b.x += nx * overlap;
      b.y += ny * overlap;

      final dvx = a.dx - b.dx;
      final dvy = a.dy - b.dy;
      final dot = dvx * nx + dvy * ny;
      if (dot > 0) {
        a.dx -= dot * nx;
        a.dy -= dot * ny;
        b.dx += dot * nx;
        b.dy += dot * ny;
      }
    }
  }

  // ─────────────────────────────────────────
  //  PHASE 3 — INTENSITY
  // ─────────────────────────────────────────
  void _startPhase3() {
    _msgFadeCtrl.forward();
    _shakeCtrl.repeat(reverse: true);
  }

  // ─────────────────────────────────────────
  //  PHASE 4 — COLLAPSE
  // ─────────────────────────────────────────
  void _triggerCollapse() {
    _shakeCtrl.stop();
    _spawnTimer?.cancel();
    setState(() {
      _phase = _Phase.phase4;
      _frozen = true;
      _shakeX = 0;
      _shakeY = 0;
    });

    try {
      SoundEffects.playCleared();
    } catch (e) {
      debugPrint('playCleared skipped: $e');
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _fallMults.clear();
      for (int i = 0; i < _balls.length; i++) {
        _fallMults.add(0.7 + _rng.nextDouble() * 0.7);
      }
      setState(() => _frozen = false);

      _fallCtrl.forward().then((_) {
        if (!mounted) return;
        setState(() => _phase = _Phase.phase5);
        _phase5Ctrl.forward();
      });
    });
  }

  // ─────────────────────────────────────────
  //  DISPOSE
  // ─────────────────────────────────────────
  @override
  void dispose() {
    _physicsTimer?.cancel();
    _spawnTimer?.cancel();
    _phaseTimer?.cancel();
    _shakeCtrl.dispose();
    _fallCtrl.dispose();
    _msgFadeCtrl.dispose();
    _phase5Ctrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  NAVIGATION
  // ─────────────────────────────────────────
  void _goHome() => Navigator.pop(context);

  // ─────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _phase == _Phase.phase5 ? _buildPhase5() : _buildPhases1to4(),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  PHASES 1–4
  // ─────────────────────────────────────────
  Widget _buildPhases1to4() {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([_shakeCtrl, _fallAnim]),
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(_shakeX, _shakeY),
          child: Stack(
            children: [
              // ── BALLS ──
              ..._buildBalls(size),

              // ── GLASS MESSAGE ──
              if (_phase == _Phase.phase1 ||
                  _phase == _Phase.phase2 ||
                  _phase == _Phase.phase3)
                _buildGlassMessage(),

              // ── URGENCY BAR (phase 3 only) ──
              if (_phase == _Phase.phase3) _buildUrgencyBar(),

              // ── FREEZE FLASH ──
              if (_frozen)
                Positioned.fill(
                  child: Container(color: Colors.white.withOpacity(0.12)),
                ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  BALLS
  // ─────────────────────────────────────────
  List<Widget> _buildBalls(Size size) {
    return List.generate(_balls.length, (i) {
      final b = _balls[i];
      double fallOffset = 0;
      if (_phase == _Phase.phase4 && i < _fallMults.length) {
        fallOffset = _fallAnim.value * size.height * 1.4 * _fallMults[i];
      }

      return Positioned(
        left: b.x - b.radius,
        top: b.y - b.radius + fallOffset,
        child: Image.asset(
          'assets/images/loading_logo.png',
          width: b.radius * 2,
          height: b.radius * 2,
        ),
      );
    });
  }

  // ─────────────────────────────────────────
  //  GLASS MESSAGE
  // ─────────────────────────────────────────
  Widget _buildGlassMessage() {
    Widget glass = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white.withOpacity(0.08),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(
                "You've reached the end of this experimental interface — for now.\n\n"
                "This experience was created to showcase a different side of development: creativity, interaction, and curiosity.\n\n"
                "To explore actual projects, experience, and work, please return to the Home Page and open the Portfolio section.\n\n"
                "This space will continue evolving as new ideas are built and tested.\n\n"
                "If you have an interesting idea, collaboration opportunity, or feedback, feel free to connect.",
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (_phase == _Phase.phase3) {
      return FadeTransition(opacity: _msgOpacity, child: glass);
    }
    return glass;
  }

  // ─────────────────────────────────────────
  //  URGENCY BAR
  // ─────────────────────────────────────────
  Widget _buildUrgencyBar() {
    final remaining = (10 - (_elapsed - 50)).clamp(0, 10);
    return Positioned(
      top: 52,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.redAccent.withOpacity(0.7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 16),
              const SizedBox(width: 6),
              Text(
                '${remaining}s',
                style: GoogleFonts.vt323(
                  fontSize: 20,
                  color: Colors.redAccent,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  PHASE 5 — EMOTIONAL MESSAGE
  // ─────────────────────────────────────────
  Widget _buildPhase5() {
    final size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: _phase5Anim,
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              children: [
                // Glow logo
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        blurRadius: 40,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/loading_logo.png',
                    width: 56,
                  ),
                ),
                const SizedBox(height: 36),

                Text(
                  'Level Complete.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 30,
                    color: Colors.white,
                    letterSpacing: 2,
                    shadows: const [
                      Shadow(color: Colors.yellowAccent, blurRadius: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                _line('You stayed through the chaos.'),
                const SizedBox(height: 28),
                _divider(),
                const SizedBox(height: 28),

                _body(
                  'Right now, the real world feels similar.\n'
                  'AI is evolving, roles are shifting,\n'
                  'and the path forward isn\'t obvious anymore.',
                ),
                const SizedBox(height: 22),
                _body('So instead of chasing certainty,\nI started building.'),
                const SizedBox(height: 22),
                _italic('Experimenting.'),
                _italic('Breaking things.'),
                _italic('Trying ideas that might not work.'),
                const SizedBox(height: 10),
                _italic('Like this.'),
                const SizedBox(height: 22),
                _body(
                  'Because sometimes,\n'
                  'the only way forward…\n'
                  'is to create your own path.',
                ),

                const SizedBox(height: 44),
                _divider(),
                const SizedBox(height: 44),

                GestureDetector(
                  onTap: _goHome,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellowAccent.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Text(
                      'Back to Home →',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 18,
                        color: Colors.black,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  TEXT HELPERS
  // ─────────────────────────────────────────
  Widget _line(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(
          fontSize: 20,
          color: Colors.white,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _body(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(
          fontSize: 17,
          color: Colors.white.withOpacity(0.85),
          height: 1.7,
        ),
      );

  Widget _italic(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(
            fontSize: 17,
            color: Colors.yellowAccent.withOpacity(0.9),
            fontStyle: FontStyle.italic,
            height: 1.6,
          ),
        ),
      );

  Widget _divider() => Row(
        children: [
          Expanded(child: Container(height: 1, color: Colors.white10)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('✦',
                style: TextStyle(color: Colors.white24, fontSize: 13)),
          ),
          Expanded(child: Container(height: 1, color: Colors.white10)),
        ],
      );
}
