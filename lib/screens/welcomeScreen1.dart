import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'welcomeScreen2.dart';

class WelcomeScreen1 extends StatefulWidget {
  const WelcomeScreen1({super.key});

  @override
  State<WelcomeScreen1> createState() => _WelcomeScreen1State();
}

class _WelcomeScreen1State extends State<WelcomeScreen1>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _textController;
  late AnimationController _buttonController;
  late AnimationController _backgroundController;

  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Floating elements controller
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Button animation controller
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Initialize animations
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Start animations in sequence
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _backgroundController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _mainController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _buttonController.forward();

    // Start floating animation and repeat
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _floatingController,
          _textController,
          _buttonController,
          _backgroundController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFF93A3EE).withOpacity(
                    (0.05 + (_backgroundAnimation.value * 0.1)).clamp(
                      0.0,
                      1.0,
                    ), // FIX: Clamp opacity value
                  ),
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              // FIX: Added scroll view to prevent overflow
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Stack(
                  children: [
                    // Animated background elements
                    ...List.generate(
                      6,
                      (index) => _buildFloatingElement(
                        index,
                        screenWidth,
                        screenHeight,
                      ),
                    ),

                    // Main content
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 80.0 : 24.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // FIX: Prevent column from expanding infinitely
                          children: [
                            // Animated brand area
                            AnimatedBuilder(
                              animation: _fadeIn,
                              builder: (context, child) => Opacity(
                                opacity: _fadeIn.value.clamp(
                                  0.0,
                                  1.0,
                                ), // FIX: Clamp opacity value
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
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
                                          borderRadius: BorderRadius.circular(
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
                                          "PRETTY SAHELI",
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF93A3EE),
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Main illustration area
                            Container(
                              height:
                                  screenHeight *
                                  0.4, // FIX: Set explicit height
                              child: Transform.translate(
                                offset: Offset(0, _slideUp.value),
                                child: Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Background glow effect
                                        Container(
                                          width: isTablet
                                              ? 350
                                              : screenWidth * 0.8,
                                          height: isTablet
                                              ? 350
                                              : screenWidth * 0.8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              colors: [
                                                const Color(
                                                  0xFF93A3EE,
                                                ).withOpacity(
                                                  (0.2 * _fadeIn.value).clamp(
                                                    0.0,
                                                    1.0,
                                                  ), // FIX: Clamp opacity value
                                                ),
                                                const Color(
                                                  0xFF93A3EE,
                                                ).withOpacity(
                                                  (0.05 * _fadeIn.value).clamp(
                                                    0.0,
                                                    1.0,
                                                  ), // FIX: Clamp opacity value
                                                ),
                                                Colors.transparent,
                                              ],
                                              stops: const [0.0, 0.6, 1.0],
                                            ),
                                          ),
                                        ),

                                        // Central logo
                                        Transform.rotate(
                                          angle:
                                              math.sin(
                                                _floatingAnimation.value *
                                                    2 *
                                                    math.pi,
                                              ) *
                                              0.05,
                                          child: Container(
                                            width: isTablet
                                                ? 280
                                                : screenWidth * 0.65,
                                            height: isTablet
                                                ? 280
                                                : screenWidth * 0.65,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF93A3EE,
                                                  ).withOpacity(0.3),
                                                  blurRadius: 40,
                                                  offset: const Offset(0, 20),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                40.0,
                                              ),
                                              child: Image.asset(
                                                "assets/logo.png",
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.spa_rounded,
                                                          size: 120,
                                                          color: Color(
                                                            0xFF93A3EE,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Orbiting elements
                                        ...List.generate(
                                          3,
                                          (index) =>
                                              _buildOrbitingElement(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Animated text content
                            AnimatedBuilder(
                              animation: _titleAnimation,
                              builder: (context, child) => Transform.translate(
                                offset: Offset(
                                  0,
                                  (1 - _titleAnimation.value) * 30,
                                ),
                                child: Opacity(
                                  opacity: _titleAnimation.value.clamp(
                                    0.0,
                                    1.0,
                                  ), // FIX: Clamp opacity value
                                  child: Column(
                                    children: [
                                      // Animated title with typewriter effect
                                      ShaderMask(
                                        shaderCallback: (bounds) =>
                                            LinearGradient(
                                              colors: [
                                                const Color(0xFF1A1B23),
                                                const Color(0xFF93A3EE),
                                              ],
                                            ).createShader(bounds),
                                        child: Text(
                                          "Expert Care,\nHome Delivered",
                                          style: TextStyle(
                                            fontSize: isTablet ? 42 : 32,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            height: 1.1,
                                            letterSpacing: -1.2,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Animated subtitle
                                      AnimatedBuilder(
                                        animation: _subtitleAnimation,
                                        builder: (context, child) =>
                                            Transform.translate(
                                              offset: Offset(
                                                0,
                                                (1 - _subtitleAnimation.value) *
                                                    20,
                                              ),
                                              child: Opacity(
                                                opacity: _subtitleAnimation
                                                    .value
                                                    .clamp(
                                                      0.0,
                                                      1.0,
                                                    ), // FIX: Clamp opacity value
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: isTablet
                                                        ? 60.0
                                                        : 30.0,
                                                  ),
                                                  child: Text(
                                                    "Skip the salon traffic. Our professionally trained stylists bring the premium salon experience to you.",
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFF64748B,
                                                      ),
                                                      fontSize: isTablet
                                                          ? 18
                                                          : 16,
                                                      height: 1.6,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.3,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Animated progress indicator
                            AnimatedBuilder(
                              animation: _buttonAnimation,
                              builder: (context, child) => Opacity(
                                opacity: _buttonAnimation.value.clamp(
                                  0.0,
                                  1.0,
                                ), // FIX: Clamp opacity value
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (index) {
                                    return AnimatedContainer(
                                      duration: Duration(
                                        milliseconds: 300 + (index * 100),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: index == 0 ? 32 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        gradient: index == 0
                                            ? const LinearGradient(
                                                colors: [
                                                  Color(0xFF93A3EE),
                                                  Color(0xFF7C3AED),
                                                ],
                                              )
                                            : null,
                                        color: index == 0
                                            ? null
                                            : const Color(0xFFE2E8F0),
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: index == 0
                                            ? [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF93A3EE,
                                                  ).withOpacity(0.4),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // animated CTA button
                            AnimatedBuilder(
                              animation: _buttonAnimation,
                              builder: (context, child) => Transform.scale(
                                scale: _buttonAnimation.value,
                                child: Container(
                                  width: isTablet ? 320 : double.infinity,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF93A3EE)
                                            .withOpacity(
                                              (0.3 * _buttonAnimation.value)
                                                  .clamp(
                                                    0.0,
                                                    1.0,
                                                  ), // FIX: Clamp opacity value
                                            ),
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
                                        borderRadius: BorderRadius.circular(20),
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
                                              ) => const WelcomeScreen2(),
                                          transitionDuration: const Duration(
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
                                                        begin: const Offset(
                                                          1.0,
                                                          0.0,
                                                        ),
                                                        end: Offset.zero,
                                                      ).animate(
                                                        CurvedAnimation(
                                                          parent: animation,
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Start Your Journey",
                                              style: TextStyle(
                                                fontSize: isTablet ? 18 : 17,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Transform.translate(
                                              offset: Offset(
                                                math.sin(
                                                      _floatingAnimation.value *
                                                          2 *
                                                          math.pi,
                                                    ) *
                                                    3,
                                                0,
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
    final size = [20.0, 16.0, 24.0, 18.0, 22.0, 14.0][index];
    final positions = [
      [0.1, 0.2],
      [0.9, 0.15],
      [0.05, 0.6],
      [0.95, 0.7],
      [0.15, 0.85],
      [0.85, 0.9],
    ];

    return Positioned(
      left: screenWidth * positions[index][0],
      top: screenHeight * positions[index][1],
      child: Transform.translate(
        offset: Offset(
          math.sin((_floatingAnimation.value + delay) * 2 * math.pi) * 10,
          math.cos((_floatingAnimation.value + delay) * 2 * math.pi) * 8,
        ),
        child: Opacity(
          opacity: (0.6 * _fadeIn.value).clamp(
            0.0,
            1.0,
          ), // FIX: Clamp opacity value
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF93A3EE).withOpacity(0.8),
                  const Color(0xFF93A3EE).withOpacity(0.2),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF93A3EE).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrbitingElement(int index) {
    final angles = [0.0, 2.094, 4.188]; // 120 degrees apart
    final radius = 160.0;
    final iconData = [
      Icons.face_retouching_natural,
      Icons.palette,
      Icons.auto_awesome,
    ][index];

    return Transform.rotate(
      angle: (_floatingAnimation.value * 2 * math.pi) + angles[index],
      child: Transform.translate(
        offset: Offset(radius, 0),
        child: Transform.rotate(
          angle: -(_floatingAnimation.value * 2 * math.pi) - angles[index],
          child: Opacity(
            opacity: (0.8 * _fadeIn.value).clamp(
              0.0,
              1.0,
            ), // FIX: Clamp opacity value
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF93A3EE).withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF93A3EE).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(iconData, color: const Color(0xFF93A3EE), size: 24),
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Button Widget with micro-interactions
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 64,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => setState(() {}),
          onTapUp: (_) => setState(() {}),
          onTapCancel: () => setState(() {}),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF93A3EE),
                    const Color(0xFF7C3AED),
                    const Color(0xFF6366F1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF93A3EE).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onPressed,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Shimmer effect
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                0.0,
                                ((_shimmerAnimation.value + 2) / 4).clamp(
                                  0.0,
                                  1.0,
                                ), // FIX: Clamp value
                                (((_shimmerAnimation.value + 2) / 4) + 0.1)
                                    .clamp(0.0, 1.0), // FIX: Clamp value
                                1.0,
                              ],
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Button content
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.text,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Transform.translate(
                            offset: Offset(
                              math.sin(_shimmerAnimation.value * math.pi) * 2,
                              0,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
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
