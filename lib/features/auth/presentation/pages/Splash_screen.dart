import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/strings.dart';
import 'package:chupachap/features/auth/presentation/widgets/getstarted_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _termsAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Image slides in from the right
    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    // Text slides in from the left
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start from the left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
    ));

    // Button slides in from the right
    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start from the right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _termsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Base gradient background
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Animated Image
                  SlideTransition(
                    position: _imageSlideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: .3),
                          border: const GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.purple,
                                Colors.red,
                                Colors.orange,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            width: 2, // Border width
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/11.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Animated Text
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          _buildAnimatedText(
                            splash1,
                            fontSize: 35,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedText(
                            splash2,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedText(
                            splash3,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Animated Button
                  SlideTransition(
                    position: _buttonSlideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const GetstartedButton(),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Terms and Conditions
                  FadeTransition(
                    opacity: _termsAnimation,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          'Terms & conditions apply',
                          style: GoogleFonts.acme(
                            color: AppColors.textPrimaryDark
                                .withValues(alpha: 0.7),
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText(
    String text, {
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.white,
          Colors.white.withValues(alpha: 0.9),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.akayaKanadaka(
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 1,
          height: 1.2,
          color: Colors.white,
          shadows: [
            Shadow(
              color: AppColors.textPrimary.withValues(alpha: 0.3),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
