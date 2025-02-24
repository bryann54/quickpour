import 'package:chupachap/core/utils/custom_snackbar_widget.dart';
import 'package:chupachap/core/wrapper/auth_wrapper.dart';
import 'package:chupachap/features/home/presentation/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          CustomAnimatedSnackbar.show(
            context: context,
            message: state.message,
            icon: Icons.error_outline,
            backgroundColor: Colors.red.withOpacity(0.9),
          );
        }

        if (state is Authenticated) {
          CustomAnimatedSnackbar.show(
            context: context,
            message: "Welcome back!",
            icon: Icons.check_circle_outline,
            backgroundColor: Colors.green.withOpacity(0.9),
          );
        }
      },
      builder: (context, state) {
        // Show loading state
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show main app if authenticated
        if (state is Authenticated) {
          return const BottomNav();
        }

        // Show auth screens if not authenticated
        return const AuthWrapper();
      },
    );
  }
}
