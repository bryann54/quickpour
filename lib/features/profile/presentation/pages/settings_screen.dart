import 'package:chupachap/core/theme/theme_toggle_switch.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Animated Sliver App Bar
          SliverAppBar(
            expandedHeight: 150,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Settings',
                style: GoogleFonts.montaga(
                  color: isDarkMode ? Colors.white : AppColors.accentColor,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryColor.withValues(alpha: 0.9),
                      AppColors.primaryColor.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.settings,
                    size: 50,
                    color: isDarkMode ? Colors.white : AppColors.accentColor,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 35.seconds, end: 1),
                ),
              ),
            ),
          ),

          // Settings Content
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
                  ..._buildSettingsSections(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSettingsSections(BuildContext context) {
    return [
      _buildSettingsSection(
        context: context,
        title: 'Preferences',
        icon: Icons.tune,
        items: [
          SettingsItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: const ThemeToggle(),
          ),
          SettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: Switch(
              value: true,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      _buildSettingsSection(
        context: context,
        title: 'Support & Legal',
        icon: Icons.support_agent,
        items: [
          SettingsItem(
            icon: FontAwesomeIcons.headset,
            title: 'Customer Service',
            subtitle: '24/7 Support',
          ),
          SettingsItem(
            icon: FontAwesomeIcons.circleInfo,
            title: 'About Us',
          ),
          SettingsItem(
            icon: FontAwesomeIcons.star,
            title: 'Rate Us',
          ),
          SettingsItem(
            icon: FontAwesomeIcons.fileContract,
            title: 'Terms & Conditions',
          ),
          SettingsItem(
            icon: FontAwesomeIcons.userShield,
            title: 'Privacy Policy',
          ),
        ],
      ),
    ];
  }

  Widget _buildSettingsSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.accentColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montaga(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: items.map((item) {
              final index = items.indexOf(item);
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.accentColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: item.subtitle != null
                        ? Text(
                            item.subtitle!,
                            style: TextStyle(
                              color:
                                  AppColors.accentColor.withValues(alpha: 0.7),
                            ),
                          )
                        : null,
                    trailing: item.trailing ??
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.accentColor.withValues(alpha: 0.5),
                        ),
                    onTap: () {},
                  ),
                  if (index != items.length - 1)
                    Divider(
                      height: 1,
                      indent: 65,
                      endIndent: 20,
                      color: AppColors.dividerColorDark.withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}
