import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/features/profile/presentation/widgets/change_password.dart';
import 'package:chupachap/features/profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:chupachap/features/profile/presentation/widgets/option_widget.dart';
import 'package:chupachap/features/profile/presentation/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'package:chupachap/features/profile/presentation/widgets/logout_button_widget.dart';
import 'package:chupachap/features/auth/data/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  final AuthUseCases authUseCases;

  const ProfileScreen({
    super.key,
    required this.authUseCases,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<User?>? _userFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _userFuture = widget.authUseCases.authRepository.getCurrentUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ProfileScreenShimmer());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching profile data',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
            );
          }

          final user = snapshot.data;

          if (user == null) {
            return Center(
              child: Text(
                'User data not found!',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Profile',
                    style: GoogleFonts.montaga(
                      textStyle: theme.textTheme.displayLarge?.copyWith(
                        color: isDarkMode
                            ? AppColors.background
                            : AppColors.backgroundDark.withOpacity(.5),
                      ),
                    ),
                  ),
                  background: _buildUserProfileHeader(user),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          _buildSectionTitle(context, 'Your Activity'),
                          const SizedBox(height: 5),
                          const ProfileStatisticsSection(),
                          const SizedBox(height: 5),
                          _buildSectionTitle(context, 'Account'),
                          const SizedBox(height: 5),
                          _buildProfileOptions(context, user),
                          const SizedBox(height: 10),
                          const LogOutButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserProfileHeader(User user) {
        final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.5),
            Colors.grey.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.accentColor.withOpacity(0.2),
            child: user.profileImage.isNotEmpty
                ? CachedNetworkImage(imageUrl: user.profileImage)
                : const Icon(Icons.person,
                    size: 50, color: AppColors.accentColor),
          ),
          const SizedBox(height: 16),
          Text(
            '${user.firstName} ${user.lastName}',
            style: GoogleFonts.acme(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:isDarkMode? Colors.white:AppColors.backgroundDark.withOpacity(.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: GoogleFonts.montaga(
              fontSize: 14,
              color: isDarkMode
                  ? Colors.white
                  : AppColors.backgroundDark.withOpacity(.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.montaga(
        textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context, User user) {
    return Card(
        elevation: 4,
   
      child: Column(
        children: [
          _buildProfileOptionItem(
            context,
            icon: Icons.edit,
            title: 'Edit Profile',
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => EditProfileDialog(
                  currentFirstName: user.firstName,
                  currentLastName: user.lastName,
                ),
              );

              if (result == true) {
                _loadUserData(); // Refresh the profile screen
              }
            },
          ),
          _buildDivider(),
          _buildProfileOptionItem(
            context,
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ChangePassword(),
              ).then((success) {
                if (success == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully'),
                    ),
                  );
                }
              });
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
     final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.accentColor,
      ),
      title: Text(
        title,
        style: GoogleFonts.acme(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      trailing:  Icon(
        Icons.arrow_forward_ios,
        size: 20,
        color: isDarkMode ? Colors.white : Colors.grey
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        height: 1,
        color: AppColors.dividerColorDark.withOpacity(0.1),
      ),
    );
  }
}
