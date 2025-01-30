import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/drink_request/presentation/pages/requests_screen.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:chupachap/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:chupachap/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:chupachap/features/orders/presentation/pages/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileStatisticsSection extends StatelessWidget {
  const ProfileStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildStatisticTile(
              context,
              icon: FontAwesomeIcons.cartShopping,
              label: "Your Orders",
              blocBuilder: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  int orderCount = 0;

                  if (state is OrdersLoaded) {
                    orderCount = state.orders.length;
                  } else if (state is OrdersEmpty) {
                    orderCount = 0;
                  }

                  return Text(orderCount.toString(),
                      style: Theme.of(context).textTheme.bodyLarge);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrdersScreen()),
                );
              },
            ),
            const Divider(),
            _buildStatisticTile(
              context,
              icon: Icons.favorite_rounded,
              label: "Your Favorites",
              blocBuilder: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  return Text(state.favorites.items.length.toString(),
                      style: Theme.of(context).textTheme.bodyLarge);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FavoritesScreen()),
                );
              },
            ),
            const Divider(),
            _buildStatisticTile(
              context,
              icon: Icons.request_page,
              label: "Your Requests",
              blocBuilder: const Text(
                '0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RequestsScreen(
                            authRepository: AuthRepository(),
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget blocBuilder,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListTile(
      leading:
          Icon(icon, size: 28, color: isDarkMode ? Colors.white : Colors.grey),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          blocBuilder,
        ],
      ),
      trailing:  Icon(Icons.arrow_forward_ios,color: isDarkMode ? Colors.white : Colors.grey),
      onTap: onTap, 
    );
  }
}
