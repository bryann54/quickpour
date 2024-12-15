import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'package:chupachap/features/home/presentation/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';

import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';


class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthUseCases _authUseCases =
      AuthUseCases(authRepository: AuthRepository());
  bool? isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    setState(() {
      isUserLoggedIn = _authUseCases.isUserSignedIn();
    });
  }

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    if (isUserLoggedIn == null) {
      // Show loading indicator while checking login status
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (isUserLoggedIn == true) {
      // Navigate to BottomNav if user is already logged in
      return BottomNav();
    } else {
      // Show login/signup screens if user is not logged in
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
                    style: TextStyle(
                      color: AppColors.errorDark,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
