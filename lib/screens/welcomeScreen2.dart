import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'welcomeScreen3.dart';

class WelcomeScreen2 extends StatefulWidget {
  const WelcomeScreen2({super.key});

  @override
  State<WelcomeScreen2> createState() => _WelcomeScreen2State();
}

class _WelcomeScreen2State extends State<WelcomeScreen2>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _kitController;
  late AnimationController _badgeController;
  late AnimationController _sparkleController;
  late AnimationController _floatingController;

  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _titleAnimation;
  late Animation<double> _kitOpenAnimation;
  late Animation<double> _badgeSlideAnimation;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _sterilizedTagAnimation;
  late Animation<double> _floatingAnimation;

  bool _showTools = false;
  bool _showBadge = false;
  bool _showSterilizedTag = false;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _kitController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _kitOpenAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _kitController, curve: Curves.elasticOut),
    );

    _badgeSlideAnimation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.bounceOut),
    );

    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _sterilizedTagAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sparkleController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mainController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _showTools = true);
    _kitController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _showBadge = true);
    _badgeController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _sparkleController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _showSterilizedTag = true);

    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _kitController.dispose();
    _badgeController.dispose();
    _sparkleController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _kitController,
          _badgeController,
          _sparkleController,
          _floatingController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFF93A3EE).withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Floating background elements
                ...List.generate(
                  6,
                  (index) =>
                      _buildFloatingElement(index, screenWidth, screenHeight),
                ),

                // Main content
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 80.0 : 24.0,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Top section
                                  Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      // Animated brand area
                                      AnimatedBuilder(
                                        animation: _fadeIn,
                                        builder: (context, child) => Opacity(
                                          opacity: _fadeIn.value.clamp(
                                            0.0,
                                            1.0,
                                          ), // FIX: Clamp opacity
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        const Color(
                                                          0xFF93A3EE,
                                                        ).withOpacity(0.1),
                                                        Colors.white,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xFF93A3EE,
                                                      ).withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "SAFETY FIRST",
                                                    style: TextStyle(
                                                      fontSize: isTablet
                                                          ? 14
                                                          : 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                        0xFF93A3EE,
                                                      ),
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Main illustration area with kit animation
                                      Container(
                                        height: math.min(
                                          screenHeight * 0.35,
                                          300, // Max height to prevent overflow
                                        ),
                                        child: Transform.translate(
                                          offset: Offset(0, _slideUp.value),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Background glow
                                              Container(
                                                width: isTablet
                                                    ? 350
                                                    : screenWidth * 0.85,
                                                height: isTablet
                                                    ? 250
                                                    : screenWidth * 0.6,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  gradient: RadialGradient(
                                                    colors: [
                                                      const Color(
                                                        0xFF93A3EE,
                                                      ).withOpacity(
                                                        (0.1 * _fadeIn.value).clamp(
                                                          0.0,
                                                          1.0,
                                                        ), // FIX: Clamp opacity
                                                      ),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // Beauty kit container
                                              _buildAnimatedKit(
                                                isTablet,
                                                screenWidth,
                                              ),

                                              // Verification badge (top right)
                                              if (_showBadge)
                                                Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child:
                                                      _buildVerificationBadge(),
                                                ),

                                              // Beautician profile (top left corner)
                                              Positioned(
                                                top: 10,
                                                left: 10,
                                                child:
                                                    _buildBeauticianProfile(),
                                              ),

                                              // Sterilized tag (bottom right of kit)
                                              if (_showSterilizedTag)
                                                Positioned(
                                                  bottom: 20,
                                                  right: 20,
                                                  child: _buildSterilizedTag(),
                                                ),

                                              // Sparkle effects
                                              ...List.generate(
                                                8,
                                                (index) => _buildSparkleEffect(
                                                  index,
                                                  isTablet,
                                                  screenWidth,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Animated text content
                                      Transform.translate(
                                        offset: Offset(0, _slideUp.value),
                                        child: Opacity(
                                          opacity: _titleAnimation.value.clamp(
                                            0.0,
                                            1.0,
                                          ), // FIX: Clamp opacity
                                          child: Column(
                                            children: [
                                              ShaderMask(
                                                shaderCallback: (bounds) =>
                                                    LinearGradient(
                                                      colors: [
                                                        const Color(0xFF1A1B23),
                                                        const Color(0xFF93A3EE),
                                                      ],
                                                    ).createShader(bounds),
                                                child: Text(
                                                  "Safety & Hygiene,\nGuaranteed",
                                                  style: TextStyle(
                                                    fontSize: isTablet
                                                        ? 32
                                                        : 24,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                    height: 1.1,
                                                    letterSpacing: -0.8,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              const SizedBox(height: 16),

                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: isTablet
                                                      ? 40.0
                                                      : 16.0,
                                                ),
                                                child: Text(
                                                  "Every expert is background-verified and uses sterilized, single-use equipment where possible.",
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF64748B,
                                                    ),
                                                    fontSize: isTablet
                                                        ? 16
                                                        : 14,
                                                    height: 1.5,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.3,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Bottom section with spacer
                                  Column(
                                    children: [
                                      const SizedBox(height: 30),

                                      // Progress indicator (second dot highlighted)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(3, (index) {
                                          return AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 300 + (index * 100),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            width: index == 1 ? 32 : 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              gradient: index == 1
                                                  ? const LinearGradient(
                                                      colors: [
                                                        Color(0xFF93A3EE),
                                                        Color(0xFF7C3AED),
                                                      ],
                                                    )
                                                  : null,
                                              color: index == 1
                                                  ? null
                                                  : const Color(0xFFE2E8F0),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              boxShadow: index == 1
                                                  ? [
                                                      BoxShadow(
                                                        color: const Color(
                                                          0xFF93A3EE,
                                                        ).withOpacity(0.4),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                          );
                                        }),
                                      ),

                                      const SizedBox(height: 30),

                                      // Simple CTA button without animation
                                      Container(
                                        width: isTablet
                                            ? 320
                                            : screenWidth * 0.85,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF93A3EE,
                                              ).withOpacity(0.3),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            HapticFeedback.lightImpact();
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                    ) => const WelcomeScreen3(),
                                                transitionDuration:
                                                    const Duration(
                                                      milliseconds: 600,
                                                    ),
                                                transitionsBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child,
                                                    ) {
                                                      return SlideTransition(
                                                        position:
                                                            Tween<Offset>(
                                                              begin:
                                                                  const Offset(
                                                                    1.0,
                                                                    0.0,
                                                                  ),
                                                              end: Offset.zero,
                                                            ).animate(
                                                              CurvedAnimation(
                                                                parent:
                                                                    animation,
                                                                curve: Curves
                                                                    .easeOutCubic,
                                                              ),
                                                            ),
                                                        child: FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        ),
                                                      );
                                                    },
                                              ),
                                            );
                                          },
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  const Color(0xFF93A3EE),
                                                  const Color(0xFF7C3AED),
                                                  const Color(0xFF6366F1),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Almost There",
                                                    style: TextStyle(
                                                      fontSize: isTablet
                                                          ? 18
                                                          : 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingElement(
    int index,
    double screenWidth,
    double screenHeight,
  ) {
    final delay = index * 0.2;
    final size = [16.0, 12.0, 20.0, 14.0, 18.0, 10.0][index];
    final positions = [
      [0.08, 0.15],
      [0.92, 0.12],
      [0.05, 0.6],
      [0.95, 0.65],
      [0.12, 0.85],
      [0.88, 0.82],
    ];

    return Positioned(
      left: screenWidth * positions[index][0],
      top: screenHeight * positions[index][1],
      child: Transform.translate(
        offset: Offset(
          math.sin((_floatingAnimation.value + delay) * 2 * math.pi) * 8,
          math.cos((_floatingAnimation.value + delay) * 2 * math.pi) * 6,
        ),
        child: Opacity(
          opacity: (0.4 * _fadeIn.value).clamp(0.0, 1.0), // FIX: Clamp opacity
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF93A3EE).withOpacity(0.6),
                  const Color(0xFF93A3EE).withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedKit(bool isTablet, double screenWidth) {
    return AnimatedBuilder(
      animation: _kitOpenAnimation,
      builder: (context, child) {
        // Adjusted sizes to prevent overflow
        final kitWidth = isTablet ? 260 : math.min(screenWidth * 0.65, 250);
        final kitHeight = isTablet ? 180 : math.min(screenWidth * 0.45, 160);

        return Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Kit base (always visible)
              Container(
                width: kitWidth * 0.9,
                height: kitHeight * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF1A1B23), const Color(0xFF2D3748)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF93A3EE).withOpacity(0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
              ),

              // Kit lid (animated opening)
              if (!_showTools)
                Container(
                  width: kitWidth * 0.9,
                  height: kitHeight * 0.9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1A1B23),
                        const Color(0xFF374151),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: const Color(0xFF93A3EE),
                      size: isTablet ? 40 : 32,
                    ),
                  ),
                ),

              // Kit interior with tools (shown after opening)
              if (_showTools)
                Transform.scale(
                  scale: _kitOpenAnimation.value,
                  child: Container(
                    width: kitWidth * 0.8,
                    height: kitHeight * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF93A3EE).withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Top row of tools
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildTool(Icons.brush_rounded, "Brush", 0),
                              _buildTool(
                                Icons.content_cut_rounded,
                                "Scissors",
                                1,
                              ),
                              _buildTool(Icons.colorize_rounded, "Tools", 2),
                            ],
                          ),
                          // Bottom row of tools
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildTool(Icons.spa_rounded, "Spa Kit", 3),
                              _buildTool(Icons.palette_rounded, "Colors", 4),
                              _buildTool(
                                Icons.sanitizer_rounded,
                                "Sanitizer",
                                5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTool(IconData icon, String label, int index) {
    final delay = index * 0.1;
    return AnimatedBuilder(
      animation: _sparkleAnimation,
      builder: (context, child) {
        final sparklePhase = (_sparkleAnimation.value + delay) % 1.0;
        final isSparklingNow = sparklePhase > 0.8;

        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSparklingNow
                ? const Color(0xFF93A3EE).withOpacity(0.2)
                : const Color(0xFFF8FAFC),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF93A3EE).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: isSparklingNow
                ? [
                    BoxShadow(
                      color: const Color(0xFF93A3EE).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(icon, color: const Color(0xFF93A3EE), size: 18),
        );
      },
    );
  }

  Widget _buildVerificationBadge() {
    return AnimatedBuilder(
      animation: _badgeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _badgeSlideAnimation.value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF10B981), const Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  "Verified",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBeauticianProfile() {
    return AnimatedBuilder(
      animation: _fadeIn,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeIn.value.clamp(0.0, 1.0), // FIX: Clamp opacity
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFF93A3EE).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF93A3EE).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              color: const Color(0xFF93A3EE),
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSterilizedTag() {
    return AnimatedBuilder(
      animation: _sterilizedTagAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _sterilizedTagAnimation.value,
          child: Opacity(
            opacity: _sterilizedTagAnimation.value.clamp(
              0.0,
              1.0,
            ), // FIX: Clamp opacity
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF93A3EE), const Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF93A3EE).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "Sterilized",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSparkleEffect(int index, bool isTablet, double screenWidth) {
    if (!_showTools) return const SizedBox.shrink();

    final positions = [
      [0.25, 0.3],
      [0.75, 0.3],
      [0.5, 0.2],
      [0.3, 0.7],
      [0.7, 0.7],
      [0.2, 0.5],
      [0.8, 0.5],
      [0.5, 0.8],
    ];

    final delay = index * 0.15;

    return AnimatedBuilder(
      animation: _sparkleAnimation,
      builder: (context, child) {
        final sparklePhase = (_sparkleAnimation.value + delay) % 1.0;
        final opacity = sparklePhase > 0.7 ? (1.0 - sparklePhase) * 3.3 : 0.0;

        final kitWidth = isTablet ? 260 : math.min(screenWidth * 0.65, 250);
        final kitHeight = isTablet ? 180 : math.min(screenWidth * 0.45, 160);

        return Positioned(
          left: kitWidth * positions[index][0],
          top: kitHeight * positions[index][1],
          child: Opacity(
            opacity: (opacity * 0.8).clamp(0.0, 1.0), // FIX: Clamp opacity
            child: Transform.scale(
              scale: sparklePhase > 0.7
                  ? 1.0 + ((sparklePhase - 0.7) * 2)
                  : 0.5,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF93A3EE),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF93A3EE).withOpacity(0.6),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
