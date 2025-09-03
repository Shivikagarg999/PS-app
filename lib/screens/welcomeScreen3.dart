import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import './login.dart';

class WelcomeScreen3 extends StatefulWidget {
  const WelcomeScreen3({super.key});

  @override
  State<WelcomeScreen3> createState() => _WelcomeScreen3State();
}

class _WelcomeScreen3State extends State<WelcomeScreen3>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _sceneController;
  late AnimationController _floatingController;
  late AnimationController _buttonController;

  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _titleAnimation;
  late Animation<double> _sceneTransition;
  late Animation<double> _buttonAnimation;

  bool _showPhone = false;
  bool _showTransformation = false;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _sceneController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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

    _sceneTransition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sceneController, curve: Curves.easeInOut),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mainController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _showPhone = true);

    await Future.delayed(const Duration(milliseconds: 600));
    _sceneController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _showTransformation = true);

    await Future.delayed(const Duration(milliseconds: 800));
    _buttonController.repeat(reverse: true);

    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _sceneController.dispose();
    _floatingController.dispose();
    _buttonController.dispose();
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
          _sceneController,
          _floatingController,
          _buttonController,
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
                                          opacity: _fadeIn.value,
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
                                                    "BEAUTY AT HOME",
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

                                      // Main illustration area with scene transition
                                      Container(
                                        height: math.min(
                                          screenHeight * 0.35,
                                          300.0,
                                        ),
                                        child: Transform.translate(
                                          offset: Offset(0, _slideUp.value),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Background glow
                                              Container(
                                                width: isTablet
                                                    ? 350.0
                                                    : screenWidth * 0.85,
                                                height: isTablet
                                                    ? 250.0
                                                    : screenWidth * 0.6,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  gradient: RadialGradient(
                                                    colors: [
                                                      const Color(
                                                        0xFF93A3EE,
                                                      ).withOpacity(
                                                        0.1 * _fadeIn.value,
                                                      ),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // Split scene illustration
                                              _buildSceneTransition(
                                                isTablet,
                                                screenWidth,
                                              ),

                                              // Phone illustration
                                              if (_showPhone)
                                                _buildPhoneIllustration(
                                                  isTablet,
                                                  screenWidth,
                                                ),

                                              // Content sigh effect
                                              if (_showTransformation)
                                                _buildContentSighEffect(
                                                  isTablet,
                                                  screenWidth,
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
                                          opacity: _titleAnimation.value,
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
                                                  "Salon Services\nAt Your Doorstep",
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
                                                  "Book professional beauty services from certified experts who come to your home. Relax while we bring the salon experience to you.",
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

                                      // Progress indicator (third dot highlighted)
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
                                            width: index == 2 ? 32.0 : 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              gradient: index == 2
                                                  ? const LinearGradient(
                                                      colors: [
                                                        Color(0xFF93A3EE),
                                                        Color(0xFF7C3AED),
                                                      ],
                                                    )
                                                  : null,
                                              color: index == 2
                                                  ? null
                                                  : const Color(0xFFE2E8F0),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              boxShadow: index == 2
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

                                      // Pulsing CTA button
                                      AnimatedBuilder(
                                        animation: _buttonController,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale:
                                                1.0 +
                                                (_buttonAnimation.value * 0.05),
                                            child: Container(
                                              width: isTablet
                                                  ? 320.0
                                                  : screenWidth * 0.85,
                                              height: 56.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.pushReplacement(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder:
                                                          (
                                                            context,
                                                            animation,
                                                            secondaryAnimation,
                                                          ) =>
                                                              const LoginScreen(),
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
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: child,
                                                            );
                                                          },
                                                    ),
                                                  );
                                                },
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        const Color(0xFF93A3EE),
                                                        const Color(0xFF7C3AED),
                                                        const Color(0xFF6366F1),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Get Started",
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
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
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
          math.sin((_floatingController.value + delay) * 2 * math.pi) * 8,
          math.cos((_floatingController.value + delay) * 2 * math.pi) * 6,
        ),
        child: Opacity(
          opacity: 0.4 * _fadeIn.value,
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

  Widget _buildSceneTransition(bool isTablet, double screenWidth) {
    final containerWidth = (isTablet ? 260 : math.min(screenWidth * 0.65, 250))
        .toDouble();
    final containerHeight = (isTablet ? 180 : math.min(screenWidth * 0.45, 160))
        .toDouble();

    return AnimatedBuilder(
      animation: _sceneTransition,
      builder: (context, child) {
        return Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF93A3EE).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Before side (left) - Going to salon
                Positioned(
                  left: 0,
                  top: 0,
                  width: containerWidth / 2,
                  height: containerHeight,
                  child: Opacity(
                    opacity: 1.0 - (_sceneTransition.value * 0.8),
                    child: Container(
                      color: const Color(0xFFF1F5F9),
                      child: Center(
                        child: Icon(
                          Icons.directions_car_rounded,
                          color: const Color(0xFF64748B),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                // After side (right) - Home salon experience
                Positioned(
                  right: 0,
                  top: 0,
                  width: containerWidth / 2,
                  height: containerHeight,
                  child: Container(
                    color: const Color(0xFFE0E7FF),
                    child: Center(
                      child: Icon(
                        Icons.home_rounded,
                        color: const Color(0xFF93A3EE),
                        size: 40,
                      ),
                    ),
                  ),
                ),

                // Transition overlay
                if (_showTransformation)
                  Positioned.fill(
                    child: Opacity(
                      opacity: _sceneTransition.value,
                      child: Container(
                        color: const Color(0xFFE0E7FF),
                        child: Center(
                          child: Icon(
                            Icons.face_retouching_natural_rounded,
                            color: const Color(0xFF93A3EE),
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneIllustration(bool isTablet, double screenWidth) {
    return AnimatedBuilder(
      animation: _sceneTransition,
      builder: (context, child) {
        final phoneOffset = Tween<double>(begin: 100, end: 0)
            .animate(
              CurvedAnimation(
                parent: _sceneController,
                curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
              ),
            )
            .value;

        return Transform.translate(
          offset: Offset(0, phoneOffset),
          child: Container(
            width: isTablet ? 80.0 : 60.0,
            height: isTablet ? 120.0 : 90.0,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1B23),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF93A3EE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                    size: isTablet ? 24 : 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentSighEffect(bool isTablet, double screenWidth) {
    return AnimatedBuilder(
      animation: _sceneTransition,
      builder: (context, child) {
        final rippleSize = Tween<double>(begin: 0, end: 30)
            .animate(
              CurvedAnimation(
                parent: _sceneController,
                curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
              ),
            )
            .value;

        final rippleOpacity = Tween<double>(begin: 1.0, end: 0.0)
            .animate(
              CurvedAnimation(
                parent: _sceneController,
                curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
              ),
            )
            .value;

        return Positioned(
          bottom: 20,
          right: 20,
          child: Opacity(
            opacity: rippleOpacity,
            child: Container(
              width: rippleSize,
              height: rippleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF93A3EE).withOpacity(0.5),
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
