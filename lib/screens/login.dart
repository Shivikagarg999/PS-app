import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import './main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _otpFocusNode = FocusNode();

  // Animation controllers - initialized as nullable
  AnimationController? _mainController;
  AnimationController? _floatingController;
  AnimationController? _formController;
  AnimationController? _buttonController;

  // Animations - also nullable initially
  Animation<double>? _fadeIn;
  Animation<double>? _slideUp;
  Animation<double>? _scaleAnimation;
  Animation<double>? _formFadeAnimation;
  Animation<double>? _buttonAnimation;
  Animation<double>? _floatingAnimation;

  bool _isLoading = false;
  bool _showOtpField = false;
  bool _isOtpVerifying = false;
  String _phoneNumber = '';
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    try {
      _mainController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      _floatingController = AnimationController(
        duration: const Duration(milliseconds: 4000),
        vsync: this,
      );

      _formController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );

      _buttonController = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );

      // Initialize animations with null checks
      _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _mainController!,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      );

      _slideUp = Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _mainController!,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
        ),
      );

      _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _mainController!,
          curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
        ),
      );

      _formFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _formController!,
          curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
        ),
      );

      _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _buttonController!,
          curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
        ),
      );

      _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _floatingController!, curve: Curves.easeInOut),
      );
    } catch (e) {
      debugPrint('Error initializing animations: $e');
    }
  }

  void _startAnimations() async {
    if (_isDisposed) return;

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!_isDisposed && _mainController != null) {
        _mainController!.forward();
      }

      await Future.delayed(const Duration(milliseconds: 600));
      if (!_isDisposed && _formController != null) {
        _formController!.forward();
      }

      await Future.delayed(const Duration(milliseconds: 400));
      if (!_isDisposed && _buttonController != null) {
        _buttonController!.forward();
      }

      if (!_isDisposed && _floatingController != null) {
        _floatingController!.repeat(reverse: true);
      }
    } catch (e) {
      debugPrint('Error starting animations: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mainController?.dispose();
    _floatingController?.dispose();
    _formController?.dispose();
    _buttonController?.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _phoneFocusNode.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.length != 10) {
      _showSnackBar('Please enter a valid 10-digit phone number');
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _showOtpField = true;
      _phoneNumber = _phoneController.text;
    });

    // Auto focus OTP field
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _otpFocusNode.requestFocus();
      }
    });

    _showSnackBar('OTP sent to +91 $_phoneNumber', isSuccess: true);
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      _showSnackBar('Please enter a valid 6-digit OTP');
      return;
    }

    if (!mounted) return;
    setState(() {
      _isOtpVerifying = true;
    });

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isOtpVerifying = false;
    });

    // Show success message
    _showSnackBar('Login successful! Welcome!', isSuccess: true);

    // Navigate to MainScreen and remove all previous routes
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess
            ? const Color(0xFF10B981)
            : const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // If animations are not initialized, show a loading state
    if (_mainController == null || _fadeIn == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController!,
          _floatingController!,
          _formController!,
          _buttonController!,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 80.0 : 24.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        children: [
                          // Logo Section
                          Transform.translate(
                            offset: Offset(0, _slideUp?.value ?? 0),
                            child: Opacity(
                              opacity: _fadeIn?.value ?? 0,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 40,
                                  bottom: 20,
                                ),
                                child: Column(
                                  children: [
                                    Transform.scale(
                                      scale: _scaleAnimation?.value ?? 1.0,
                                      child: Container(
                                        width: isTablet ? 120 : 100,
                                        height: isTablet ? 120 : 100,
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
                                          padding: const EdgeInsets.all(16.0),
                                          child: Image.asset(
                                            'assets/logo.png',
                                            width: isTablet ? 100 : 80,
                                            height: isTablet ? 100 : 80,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Login Form
                          Transform.translate(
                            offset: Offset(0, _slideUp?.value ?? 0),
                            child: Opacity(
                              opacity: _formFadeAnimation?.value ?? 0,
                              child: Container(
                                padding: EdgeInsets.all(isTablet ? 32 : 24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF93A3EE,
                                      ).withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Welcome Back!",
                                      style: TextStyle(
                                        fontSize: isTablet ? 24 : 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1B23),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Sign in to continue your beauty journey",
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        color: const Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // Phone Number Input
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _phoneController,
                                        focusNode: _phoneFocusNode,
                                        enabled: !_showOtpField,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1A1B23),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Phone Number",
                                          hintStyle: TextStyle(
                                            color: const Color(0xFF94A3B8),
                                            fontSize: isTablet ? 14 : 13,
                                          ),
                                          prefixIcon: Container(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              "+91",
                                              style: TextStyle(
                                                fontSize: isTablet ? 16 : 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF1A1B23),
                                              ),
                                            ),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.all(
                                            16,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // OTP Input
                                    if (_showOtpField) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8FAFC),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE2E8F0),
                                            width: 1,
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _otpController,
                                          focusNode: _otpFocusNode,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          style: TextStyle(
                                            fontSize: isTablet ? 18 : 16,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1A1B23),
                                            letterSpacing: 8,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Enter OTP",
                                            hintStyle: TextStyle(
                                              color: const Color(0xFF94A3B8),
                                              fontSize: isTablet ? 14 : 12,
                                              letterSpacing: 1,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.all(16),
                                          ),
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 24),

                                    // Login Button
                                    Transform.scale(
                                      scale: _buttonAnimation?.value ?? 1.0,
                                      child: Container(
                                        width: double.infinity,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
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
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          onPressed:
                                              (_isLoading || _isOtpVerifying)
                                              ? null
                                              : (_showOtpField
                                                    ? _verifyOtp
                                                    : _sendOtp),
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
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child:
                                                  _isLoading || _isOtpVerifying
                                                  ? const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(Colors.white),
                                                      ),
                                                    )
                                                  : Text(
                                                      _showOtpField
                                                          ? "Verify OTP"
                                                          : "Send OTP",
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
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Divider
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Text(
                                            "OR",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 24),

                                    // Google Sign In Button
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                          width: 1,
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(
                                            0xFF1A1B23,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Handle Google sign in
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.account_circle,
                                              color: Color(0xFF93A3EE),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Continue with Google",
                                              style: TextStyle(
                                                fontSize: isTablet ? 16 : 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Security Info
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.security_rounded,
                                            color: const Color(0xFF93A3EE),
                                            size: isTablet ? 20 : 16,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Your information is securely encrypted",
                                              style: TextStyle(
                                                fontSize: isTablet ? 14 : 12,
                                                color: const Color(0xFF64748B),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Terms and Privacy Policy
                          Opacity(
                            opacity: _fadeIn?.value ?? 0,
                            child: Text.rich(
                              TextSpan(
                                text: "By continuing, you agree to our ",
                                style: TextStyle(
                                  fontSize: isTablet ? 12 : 10,
                                  color: const Color(0xFF64748B),
                                ),
                                children: [
                                  TextSpan(
                                    text: "Terms of Service",
                                    style: TextStyle(
                                      fontSize: isTablet ? 12 : 10,
                                      color: const Color(0xFF93A3EE),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      fontSize: isTablet ? 12 : 10,
                                      color: const Color(0xFF93A3EE),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
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
          math.sin(((_floatingAnimation?.value ?? 0) + delay) * 2 * math.pi) *
              8,
          math.cos(((_floatingAnimation?.value ?? 0) + delay) * 2 * math.pi) *
              6,
        ),
        child: Opacity(
          opacity: 0.4 * (_fadeIn?.value ?? 0),
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
}
