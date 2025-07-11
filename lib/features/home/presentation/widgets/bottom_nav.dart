import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/pages/cart_page.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:chupachap/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:chupachap/features/home/presentation/pages/home_screen.dart';
import 'package:chupachap/features/orders/presentation/pages/orders_screen.dart';
import 'package:chupachap/features/product_search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final GlobalKey _bottomNavigationKey = GlobalKey();
  int _currentIndex = 2;
  // List of screens corresponding to navigation items
  final List<Widget> _screens = [
    SearchPage(
      authRepository: AuthRepository(),
    ),
    const FavoritesScreen(),
    const HomeScreen(),
    const CartPage(),
    const OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentIndex,
        height: 60.0,
        items: [
          FaIcon(FontAwesomeIcons.magnifyingGlass,
              size: 25,
              color: isDarkMode
                  ? Colors.grey.shade400.withValues(alpha: .9)
                  : Colors.white),

          // Favorites with badge
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, favoritesState) {
              return badges.Badge(
                badgeContent: Text(
                  '${favoritesState.favorites.items.length}',
                  style: const TextStyle(color: Colors.white),
                ),
                showBadge: favoritesState.favorites.items.isNotEmpty,
                child: FaIcon(FontAwesomeIcons.solidHeart,
                    size: 25,
                    color: isDarkMode
                        ? Colors.grey.shade400.withValues(alpha: .9)
                        : Colors.white),
              );
            },
          ),
          FaIcon(FontAwesomeIcons.houseChimney,
              size: 25,
              color: isDarkMode
                  ? Colors.grey.shade400.withValues(alpha: .9)
                  : Colors.white),

          // Cart with badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return badges.Badge(
                badgeContent: Text(
                  '${cartState.cart.totalQuantity}',
                  style: const TextStyle(color: Colors.white),
                ),
                showBadge: cartState.cart.totalQuantity > 0,
                child: FaIcon(FontAwesomeIcons.cartShopping,
                    size: 25,
                    color: isDarkMode
                        ? Colors.grey.shade400.withValues(alpha: .9)
                        : Colors.white),
              );
            },
          ),

          FaIcon(FontAwesomeIcons.clipboardList,
              size: 25,
              color: isDarkMode
                  ? Colors.grey.shade400.withValues(alpha: .9)
                  : Colors.white),
        ],
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.primaryColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
