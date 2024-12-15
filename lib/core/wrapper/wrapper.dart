import 'package:chupachap/core/utils/custom_snackbar_widget.dart';
import 'package:chupachap/core/wrapper/auth_wrapper.dart';
import 'package:chupachap/features/home/presentation/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // Show the custom snackbar if there's an error
          CustomAnimatedSnackbar.show(
            context: context,
            message: "Authentication Error: ${state.message}",
            icon: Icons.error_outline,
            backgroundColor: Colors.red,
          );
        }

        if (state is Authenticated) {
          // Show the welcome back snackbar when authenticated
          CustomAnimatedSnackbar.show(
            context: context,
            message: "Welcome back!!",
            icon: Icons.check_circle_outline,
            backgroundColor: Colors.green,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            // Show loading indicator while authentication is in progress
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is Authenticated) {
            // If the user is authenticated, show the bottomnav
            return BottomNav(); // Your home screen widget
          } else {
            // If not authenticated, show the login screen
            return AuthWrapper(); 
          }
        },
      ),
    );
  }
}
