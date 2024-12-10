import 'package:chupachap/features/orders/presentation/pages/orders_screen.dart';
import 'package:chupachap/features/profile/presentation/pages/profile_screen.dart';

import 'package:chupachap/features/profile/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showNotification;
  final bool showProfile;
  final double iconSize;
  final Color? iconColor;
  final ThemeData? theme;
  final String? title;

  const CustomAppBar({
    Key? key,
    this.showNotification = true,
    this.showProfile = true,
    this.iconSize = 27,
    this.iconColor,
    this.theme,
    this.title,
  }) : super(key: key);

  void _handleNotificationTap(BuildContext context) {
    print('Notification tapped');
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    final iconColorWithTheme = iconColor ?? currentTheme.iconTheme.color;

    return AppBar(
      title: title != null
          ? Text(title!, style: currentTheme.textTheme.titleLarge)
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                SizedBox(
                  height: 127,
                  width: 127,
                  child: Image.asset(
                    'assets/splash.png',
                    fit: BoxFit.contain,
                  ),
                ),
                // Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showNotification)
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications_outlined,
                            size: iconSize,
                            color: iconColorWithTheme,
                          ),
                          onPressed: () => _handleNotificationTap(context),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    if (showProfile)
                      SizedBox(
                        width: 40,
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.person_outline,
                            size: iconSize,
                            color: iconColorWithTheme,
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'settings':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                           const SettingsScreen()));
                                break;
                              case 'profile':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen()));
                                break;
                              case 'Orders':
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>OrdersScreen()));
                                break;
                              case 'logout':
                                print('Logout tapped');
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'settings',
                              child: Row(
                                children: [
                                  Icon(Icons.settings, size: 20),
                                  SizedBox(width: 10),
                                  Text('Settings'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'profile',
                              child: Row(
                                children: [
                                  Icon(Icons.person, size: 20),
                                  SizedBox(width: 10),
                                  Text('Profile'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Orders',
                              child: Row(
                                children: [
                                  Icon(Icons.shopping_bag, size: 20),
                                  SizedBox(width: 10),
                                  Text('Orders'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout, size: 20),
                                  SizedBox(width: 10),
                                  Text('Logout'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
      backgroundColor: currentTheme.appBarTheme.backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
