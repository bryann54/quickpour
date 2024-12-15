import 'package:chupachap/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:chupachap/features/home/presentation/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          // Show loading indicator while authentication is in progress
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is Authenticated) {
          // If the user is authenticated, show the Home screen
          return BottomNav(); // Your home screen widget
        } else if (state is AuthError) {
          // Show an error screen or snackbar if there's an error
          return Scaffold(
            body: Center(
              child: Text(
                "Authentication Error: ${state.message}",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          // If not authenticated, show the login screen
          return AuthWrapper(); // This widget will wrap the Login or Signup screen
        }
      },
    );
  }
}
