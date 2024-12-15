import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLogin = true; // Track whether the user wants to log in or sign up

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(color: AppColors.errorDark,fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
