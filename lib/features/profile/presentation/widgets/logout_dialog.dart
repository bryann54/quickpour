import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomLogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomLogoutDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return AlertDialog.adaptive(
      backgroundColor: isDarkMode
          ? AppColors.cardColorDark
          : AppColors.cardColor, // Custom color for the dialog
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      title: const Text(
        'confirm logout',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: const Text(
        'are you Sure you want to log out?',
        style: TextStyle(fontSize: 16),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onCancel, // Cancel action
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'cancel',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onConfirm, // Confirm (logout) action
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'logout',
                      style: TextStyle(
                        color: AppColors.textPrimary, // Custom text color
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
