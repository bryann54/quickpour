import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';

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
            // Perform logout logic here
            Navigator.of(context).pop(); // Close the dialog
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
                'logout',
                style: TextStyle(
                  color: 
                    
                       AppColors.textPrimaryDark,
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
