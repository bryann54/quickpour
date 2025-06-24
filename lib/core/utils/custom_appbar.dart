import 'package:chupachap/features/user_data/presentation/widgets/custom_greetings.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/pages/cart_page.dart';
import 'package:chupachap/features/drink_request/presentation/pages/requests_screen.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:chupachap/features/profile/presentation/pages/profile_screen.dart';
import 'package:chupachap/features/profile/presentation/pages/settings_screen.dart';
import 'package:chupachap/features/wallet/presentation/pages/wallet_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showNotification;
  final bool showCart;
  final bool showProfile;
  final bool useCartFAB;
  final bool showGreeting;
  final double iconSize;
  final String? userName;
  final Color? iconColor;
  final ThemeData? theme;
  final String? title;
  final FloatingActionButtonLocation? fabLocation;
  final PreferredSizeWidget? bottom;
  final userEmail =
      FirebaseAuth.instance.currentUser?.email ?? 'No email found';
  final authUseCases = AuthUseCases(authRepository: AuthRepository());
  final double toolbarHeight;

  CustomAppBar({
    Key? key,
    this.showNotification = true,
    this.showGreeting = false,
    this.showCart = true,
    this.showProfile = true,
    this.useCartFAB = false,
    this.bottom,
    this.iconSize = 27,
    this.iconColor,
    this.theme,
    this.title,
    this.fabLocation,
    this.toolbarHeight = 60,
    this.userName,
  }) : super(key: key);
  void _handleNotificationTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  Widget _buildNotificationIcon(BuildContext context,
      NotificationsState notificationsState, ThemeData currentTheme) {
    final iconColorWithTheme = iconColor ?? currentTheme.iconTheme.color;

    return badges.Badge(
      badgeContent: Text(
        '${notificationsState.unreadCount}',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      showBadge: notificationsState.unreadCount > 0,
      child: FaIcon(
        FontAwesomeIcons.bell,
        size: 22,
        color: iconColorWithTheme!.withValues(alpha: .7),
      ),
    );
  }

  void _handleCartTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    final iconColorWithTheme = iconColor ?? currentTheme.iconTheme.color;

    return AppBar(
      toolbarHeight: toolbarHeight,
      title: title != null
          ? Text(title!, style: currentTheme.textTheme.titleLarge)
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Conditional Greeting or Logo
                Expanded(
                  flex: 3,
                  child: showGreeting
                      ? const CustomGreeting()
                      : ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFE74C3C),
                              Color(0xFFF39C12),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Alko Hut',
                            style: GoogleFonts.acme(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                // Icons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showNotification)
                      SizedBox(
                        width: 40,
                        child:
                            BlocBuilder<NotificationsBloc, NotificationsState>(
                          builder: (context, notificationsState) {
                            return IconButton(
                              icon: _buildNotificationIcon(
                                context,
                                notificationsState,
                                currentTheme,
                              ),
                              onPressed: () => _handleNotificationTap(context),
                              padding: EdgeInsets.zero,
                            );
                          },
                        ),
                      ),
                    if (showCart && !useCartFAB)
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, cartState) {
                          return SizedBox(
                            width: 40,
                            child: badges.Badge(
                              badgeContent: Text(
                                '${cartState.cart.totalQuantity}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              showBadge: cartState.cart.totalQuantity > 0,
                              child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.cartShopping,
                                  size: 22,
                                  color:
                                      iconColorWithTheme!.withValues(alpha: .7),
                                ),
                                onPressed: () => _handleCartTap(context),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          );
                        },
                      ),
                    if (showProfile)
                      SizedBox(
                        width: 40,
                        child: PopupMenuButton<String>(
                          icon: FaIcon(
                            FontAwesomeIcons.circleUser,
                            size: 22,
                            color: iconColorWithTheme!.withValues(alpha: .7),
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
                                        builder: (context) => ProfileScreen(
                                              authUseCases: authUseCases,
                                            )));
                                break;
                              case 'Requests':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RequestsScreen(
                                              authRepository: AuthRepository(),
                                            )));

                                break;
                              case 'wallet':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WalletScreen()));
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'settings',
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.cog, size: 20),
                                  SizedBox(width: 10),
                                  Text('Settings'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'profile',
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.circleUser, size: 20),
                                  SizedBox(width: 10),
                                  Text('Profile'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Requests',
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.envelope, size: 20),
                                  SizedBox(width: 10),
                                  Text('Requests'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'wallet',
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.wallet, size: 20),
                                  SizedBox(width: 10),
                                  Text('wallet'),
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
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return _buildAppBar(context);
  }
}
