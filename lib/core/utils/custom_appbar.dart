import 'package:chupachap/core/utils/custom_greetings.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/pages/cart_page.dart';
import 'package:chupachap/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:chupachap/features/profile/presentation/pages/profile_screen.dart';
import 'package:chupachap/features/profile/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showNotification;
  final bool showCart;
  final bool showProfile;
  final bool useCartFAB;
  final bool showGreeting;
  final double iconSize;
  final Color? iconColor;
  final ThemeData? theme;
  final String? title;
  final FloatingActionButtonLocation? fabLocation;

  const CustomAppBar({
    Key? key,
    this.showNotification = true,
    this.showGreeting =false,
    this.showCart = true,
    this.showProfile = true,
    this.useCartFAB = false,
    this.iconSize = 27,
    this.iconColor,
    this.theme,
    this.title,
    this.fabLocation,
  }) : super(key: key);

  void _handleNotificationTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  NotificationsScreen()),
    );
  }

  void _handleCartTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }
  Widget _buildCartIcon(
      BuildContext context, CartState cartState, ThemeData currentTheme) {
    final iconColorWithTheme = iconColor ?? currentTheme.iconTheme.color;

    return badges.Badge(
      badgeContent: Text(
        '${cartState.cart.totalQuantity}',
        style: const TextStyle(color: Colors.white),
      ),
      showBadge: cartState.cart.totalQuantity > 0,
      child: FaIcon(
        FontAwesomeIcons.cartShopping,
        size: 22,
        color: iconColorWithTheme,
      ),
    );
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
                // Conditional Greeting or Logo
                showGreeting
                    ? const CustomGreeting(
                      //to be changed to use user name from model
                       userName: 'Brian', 
                    )

                    : SizedBox(
                        height: 127,
                        width: 100,
                        child: Image.asset(
                          'assets/splash.png',
                          fit: BoxFit.contain,
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
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.bell,
                            size: 22,
                            color: iconColorWithTheme!.withOpacity(.7),
                          ),
                          onPressed: () => _handleNotificationTap(context),
                          padding: EdgeInsets.zero,
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
                                style: const TextStyle(color: Colors.white,fontSize: 12),
                              ),
                              showBadge: cartState.cart.totalQuantity > 0,
                              child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.cartShopping,
                                  size: 22,
                                  color: iconColorWithTheme!.withOpacity(.7),
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
                            color: iconColorWithTheme!.withOpacity(.7),
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
                                        builder: (context) =>
                                            const ProfileScreen()));
                   
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
                                 FaIcon(
                            FontAwesomeIcons.cog, size: 20),
                                  SizedBox(width: 10),
                                  Text('Settings'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'profile',
                              child: Row(
                                children: [
                                  FaIcon(
                            FontAwesomeIcons.userCircle, size: 20),
                                  SizedBox(width: 10),
                                  Text('Profile'),
                                ],
                              ),
                            ),
                     
                            const PopupMenuItem<String>(
                              value: 'logout',
                              child: Row(
                                children: [
                                FaIcon(FontAwesomeIcons.rightFromBracket, size: 20),
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
      floatingActionButton: showCart && useCartFAB
          ? BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                return FloatingActionButton(
                  onPressed: () => _handleCartTap(context),
                  child: _buildCartIcon(context, cartState, Theme.of(context)),
                );
              },
            )
          : null,
      floatingActionButtonLocation: useCartFAB
          ? (fabLocation ?? FloatingActionButtonLocation.endFloat)
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
