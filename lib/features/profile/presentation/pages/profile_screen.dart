import 'dart:io';

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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

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
                expandedHeight: 250,
                pinned: true,
                stretch: true,
                iconTheme: IconThemeData(
                    color: isDarkMode ? Colors.white : Colors.white),
                backgroundColor: isDarkMode
                    ? AppColors.backgroundDark
                    : AppColors.primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image with Shader
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent.withOpacity(.9),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.darken,
                        child: Image.asset(
                          'assets/111.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Profile Information
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Hero(
                                  tag: 'profile_avatar',
                                  child: CircleAvatar(
                                    radius: 75,
                                    backgroundColor: Colors.grey,
                                    child: CircleAvatar(
                                      radius: 77,
                                      backgroundColor: AppColors.accentColor
                                          .withOpacity(0.2),
                                      backgroundImage: _pickedImage != null
                                          ? FileImage(File(_pickedImage!.path))
                                          : (user.profileImage.isNotEmpty
                                              ? CachedNetworkImageProvider(
                                                  user.profileImage)
                                              : null) as ImageProvider?,
                                      child: user.profileImage.isEmpty &&
                                              _pickedImage == null
                                          ? const Icon(Icons.person,
                                              size: 50,
                                              color: AppColors.accentColor)
                                          : null,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: _pickImage,
                                    icon: const Icon(Icons.camera_alt,
                                        color: AppColors.accentColor, size: 30),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.firstName,
                                  style: GoogleFonts.montaga(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user.lastName,
                                  style: GoogleFonts.montaga(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                                .animate()
                                .fadeIn(duration: 1000.ms)
                                .slideX(begin: 0.1),
                            Text(
                              user.email,
                              style: const TextStyle(color: Colors.white70),
                            )
                                .animate()
                                .fadeIn(duration: 1000.ms)
                                .slideX(begin: 0.1),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                          const ProfileStatisticsSection()
                              .animate()
                              .fadeIn(duration: 1000.ms)
                              .slideX(begin: 0.1),
                          const SizedBox(height: 5),
                          _buildSectionTitle(context, 'Account'),
                          const SizedBox(height: 5),
                          _buildProfileOptions(context, user)
                              .animate()
                              .fadeIn(duration: 1000.ms)
                              .slideX(begin: 0.1),
                          const SizedBox(height: 10),
                          const LogOutButton()
                              .animate()
                              .fadeIn(duration: 1000.ms)
                              .slideX(begin: 0.1),
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
      leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          ),
          child: Icon(icon,
              size: 28, color: isDarkMode ? Colors.white : Colors.grey)),
      title: Text(title, style: theme.textTheme.bodyMedium),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 20, color: isDarkMode ? Colors.white : Colors.grey),
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
