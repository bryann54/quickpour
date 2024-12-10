
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/pages/cart_page.dart';
import 'package:chupachap/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:chupachap/features/orders/presentation/pages/orders_screen.dart';
import 'package:chupachap/features/profile/presentation/pages/profile_screen.dart';
import 'package:chupachap/features/profile/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showNotification;
  final bool showCart;
  final bool showProfile;
  final bool useCartFAB;
  final double iconSize;
  final Color? iconColor;
  final ThemeData? theme;
  final String? title;
  final FloatingActionButtonLocation? fabLocation;

  const CustomAppBar({
    Key? key,
    this.showNotification = true,
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
    // Add your notification navigation/logic here
    print('Notification tapped');
  }

  void _handleCartTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  void _handleProfileTap(BuildContext context) {
    // Add your profile navigation/logic here
    print('Profile tapped');
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
      child: Icon(
        Icons.shopping_cart_outlined,
        size: iconSize,
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
                // Logo
                SizedBox(
                  height: 127,
                  width: 100,
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
                    if (showCart && !useCartFAB)
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, cartState) {
                          return SizedBox(
                            width: 40,
                            child: badges.Badge(
                              badgeContent: Text(
                                '${cartState.cart.totalQuantity}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              showBadge: cartState.cart.totalQuantity > 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  size: iconSize,
                                  color: iconColorWithTheme,
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
                                        builder: (context) => const ProfileScreen()));
                                break;
                              case 'favorites':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FavoritesScreen()));
                                break;
                              case 'Orders':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const OrdersScreen()));
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
                              value: 'favorites',
                              child: Row(
                                children: [
                                  Icon(Icons.favorite, size: 20),
                                  SizedBox(width: 10),
                                  Text('Favorites'),
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
