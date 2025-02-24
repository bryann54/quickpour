import 'package:chupachap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chupachap/features/auth/presentation/pages/Splash_screen.dart';
import 'package:chupachap/features/home/presentation/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:chupachap/core/utils/colors.dart';

class EntrySplashScreen extends StatefulWidget {
  const EntrySplashScreen({super.key});

  @override
  State<EntrySplashScreen> createState() => _EntrySplashScreenState();
}

class _EntrySplashScreenState extends State<EntrySplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundFadeAnimation;
  bool _authCheckComplete = false;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuth();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _backgroundFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _animationController.forward().then((_) {
      setState(() {
        _animationComplete = true;
      });
      _navigateBasedOnAuth();
    });
  }

  Future<void> _checkAuth() async {
    final authBloc = context.read<AuthBloc>();

    try {
      if (authBloc.authUseCases.isUserSignedIn()) {
        setState(() {
          _authCheckComplete = true;
        });
        _navigateBasedOnAuth();
      } else {
        setState(() {
          _authCheckComplete = true;
        });
        _navigateBasedOnAuth();
      }
    } catch (e) {
      setState(() {
        _authCheckComplete = true;
      });
      _navigateBasedOnAuth();
    }
  }

  void _navigateBasedOnAuth() {
    if (_authCheckComplete && _animationComplete) {
      final authBloc = context.read<AuthBloc>();

      if (authBloc.authUseCases.isUserSignedIn()) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const BottomNav()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              Opacity(
                opacity: _backgroundFadeAnimation.value,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: _backgroundFadeAnimation.value * 0.1,
                child: Container(),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
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
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 20,
                                spreadRadius: 5,
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
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Text(
                        'Alko Hut',
                        style: GoogleFonts.chewy(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                color: AppColors.shadowColor,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Text(
                        'Drink yako Pap!!',
                        style: GoogleFonts.tangerine(
                          color: AppColors.background,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
