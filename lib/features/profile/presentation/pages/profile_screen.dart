
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/home/presentation/widgets/logout_button_widget.dart';
import 'package:chupachap/features/home/presentation/widgets/option_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {


  const ProfileScreen({super.key,});

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: Text(
                  'Profile',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: isDarkMode
                        ? AppColors.cardColor
                        : AppColors.accentColorDark,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // User Profile Section
              _buildUserProfileHeader(context),

              const SizedBox(height: 24),

              // User Activity Section
              _buildSectionTitle(context, 'Your Activity'),
              const SizedBox(height: 12),
              const ProfileStatisticsSection(),

              const SizedBox(height: 24),

              // Profile Options
              _buildSectionTitle(context, 'Account'),
              const SizedBox(height: 12),
              _buildProfileOptions(context),

              const SizedBox(height: 24),

              // Logout Button
              const LogOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: 'profile_avatar',
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.accentColor.withOpacity(0.2),
            // ignore: unnecessary_null_comparison
            backgroundImage: 'user.profileImage' != null
                ?const NetworkImage('ser.profileImage')
                : null,
            // child: user.profileImage == null
            //     ? Icon(
            //         Icons.person,
            //         size: 50,
            //         color: AppColors.accentColor,
            //       )
            //     : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'user.name',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
               ' user.email',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Text(
              //   'Joined ${_formatJoinDate(user.createdAt)}',
              //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //         color: Colors.grey,
              //       ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _buildProfileOptionItem(
            context,
            icon: Icons.edit,
            title: 'Edit Profile',
            onTap: () {
              // TODO: Implement edit profile navigation
            },
          ),
          _buildDivider(),
          _buildProfileOptionItem(
            context,
            icon: Icons.settings,
            title: 'Account Settings',
            onTap: () {
              // Navigate to settings screen
              context.push('/settings');
            },
          ),
          _buildDivider(),
          _buildProfileOptionItem(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // TODO: Implement help & support navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.accentColor,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        height: 1,
        color: AppColors.dividerColorDark.withOpacity(0.3),
      ),
    );
  }

  String _formatJoinDate(DateTime? createdAt) {
    if (createdAt == null) return 'Unknown';

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return '${months[createdAt.month - 1]} ${createdAt.year}';
  }
}
