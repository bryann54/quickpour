import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/home/presentation/widgets/bottom_nav.dart';
import '../../features/auth/presentation/pages/Splash_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLogin = true;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authBloc = context.read<AuthBloc>();

    try {
      // Check if user is signed in
      if (authBloc.authUseCases.isUserSignedIn()) {
        // Attempt to get user details
        final user = await authBloc.authUseCases.getCurrentUserDetails();

        if (user != null) {
          // User is fully authenticated, navigate to BottomNav
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => BottomNav()),
          );
        } else {
          // No user details found, navigate to Splash/Signup
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SplashScreen()),
          );
        }
      } else {
        // No user signed in, set to signup
        setState(() {
          isLogin = false;
          _isChecking = false;
        });
      }
    } catch (e) {
      // Error in authentication, default to login
      setState(() {
        isLogin = true;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while checking authentication
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        showCart: false,
        showNotification: false,
        showProfile: false,
      ),
      body: isLogin ? const LoginScreen() : const SignupScreen(),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isLogin
                  ? "Don't have an account?"
                  : "Already have an account?"),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin ? "Sign Up" : "Login",
                  style: TextStyle(color: AppColors.errorDark, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
