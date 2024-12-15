import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_event.dart';
import 'package:chupachap/features/home/presentation/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({super.key});

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomLogoutDialog(
          onConfirm: () {
            // Perform the logout logic here
            _logout();
            Navigator.of(context).pop(); // Close the dialog
          },
          onCancel: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  void _logout() {
    // You can perform logout logic here, like clearing user data or tokens
    // For example, if using BLoC:
    BlocProvider.of<AuthBloc>(context).add(LogoutEvent());

    // Optionally, you can also clear shared preferences or tokens directly:
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.clear(); // Clear stored user data (example for SharedPreferences)
    // });

    // After logout, navigate to the login screen (or any other screen)
    Navigator.pushReplacementNamed(context, '/login'); // Adjust route as needed
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        shadowColor: isLightMode
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLogoutConfirmationDialog,
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
              child: Text(
                'Logout',
                style: TextStyle(
                  color: isLightMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
