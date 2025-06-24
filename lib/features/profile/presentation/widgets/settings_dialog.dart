import 'package:chupachap/core/theme/theme_toggle_switch.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.accentColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Settings',
                style: GoogleFonts.montaga(
                  textStyle: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'App Appearance',
              style: GoogleFonts.montaga(
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.accentColor,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundDark.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accentColor.withValues(alpha: 0.2),
                ),
              ),
              child: _buildSettingsItem(
                context,
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                trailing: const ThemeToggle(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Notifications',
              style: GoogleFonts.montaga(
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.accentColor,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundDark.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accentColor.withValues(alpha: 0.2),
                ),
              ),
              child: _buildSettingsItem(
                context,
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: _toggleNotifications,
                  activeColor: AppColors.accentColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: GoogleFonts.acme(
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.accentColor,
      ),
      title: Text(
        title,
        style: GoogleFonts.acme(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
