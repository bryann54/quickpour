import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/home/presentation/widgets/bottom_nav.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_snackbar_widget.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          CustomAnimatedSnackbar.show(
            context: context,
            message: "Authentication Error: ${state.message}",
            icon: Icons.error_outline,
            backgroundColor: Colors.red,
          );
        }

        if (state is Authenticated) {
          CustomAnimatedSnackbar.show(
            context: context,
            message: "Welcome back!!",
            icon: Icons.check_circle_outline,
            backgroundColor: Colors.green,
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const BottomNav()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.background,
              ),
            ),
          );
        }

        return Scaffold(
          body: isLogin ? const LoginScreen() : const SignupScreen(),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? "Don't have an account?"
                        : "Already have an account?",
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? "Sign Up" : "Login",
                      style: const TextStyle(
                        color: AppColors.errorDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
}
