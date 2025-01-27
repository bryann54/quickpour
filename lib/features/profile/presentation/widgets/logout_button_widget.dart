import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/presentation/pages/entry_splash.dart';
import 'package:chupachap/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_event.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_state.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({super.key});

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomLogoutDialog(
          onConfirm: () {
            Navigator.of(context).pop(); // Close the dialog
            context.read<AuthBloc>().add(LogoutEvent());
          },
          onCancel: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const EntrySplashScreen()),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5,
          shadowColor: isLightMode
              ? Colors.black.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final bool isLoading = state is AuthLoading;

              return InkWell(
                onTap: isLoading ? null : _showLogoutConfirmationDialog,
                borderRadius: BorderRadius.circular(10),
                child: Ink(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: isLightMode
                        ? AppColors.lightButtonGradient
                        : AppColors.darkButtonGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
