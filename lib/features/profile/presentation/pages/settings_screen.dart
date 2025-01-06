import 'package:chupachap/core/theme/theme_toggle_switch.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        showProfile: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with subtle animation
              Center(
                child: Text('App Settings',
                    style: GoogleFonts.montaga(
                      textStyle: theme.textTheme.displayLarge?.copyWith(
                        color: isDarkMode
                            ? AppColors.cardColor
                            : AppColors.accentColorDark,
                      ),
                    )).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
              ),
              const SizedBox(height: 20),

              // Dark Mode Setting
              _buildSettingsSection(
                context,
                title: 'App Appearance',
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: const ThemeToggle(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Account Settings
              _buildSettingsSection(
                context,
                title: 'Account',
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      // TODO: Navigate to edit profile screen
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      // TODO: Navigate to change password screen
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Notification Settings
              _buildSettingsSection(
                context,
                title: 'Notifications',
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notification Preferences',
                    onTap: () {
                      // TODO: Navigate to notification settings
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Support and Legal
              _buildSettingsSection(
                context,
                title: 'Support',
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      // TODO: Navigate to support screen
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      // TODO: Navigate to privacy policy
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      // TODO: Implement logout functionality
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build settings sections
  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(title,
              style: GoogleFonts.montaga(
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentColor,
                    fontSize: 17),
              )),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentColor.withOpacity(0.2),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  // Helper method to build individual settings items
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
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Helper method to create dividers
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        height: 1,
        color: AppColors.dividerColorDark.withOpacity(0.3),
      ),
    );
  }
}
