import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/home/presentation/widgets/bottom_nav.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_item_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
 

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
          (route) => false, // Removes all previous routes from the stack
        );
        return false; // Prevent the default back navigation
      },
      child: Scaffold(
        appBar: CustomAppBar(
          showCart: false,
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersInitial) {
              return const Center(
                child: OrderShimmer(),
              );
            } else if (state is OrdersEmpty) {
              return _buildEmptyOrdersView(context);
            } else if (state is OrdersLoaded) {
              return _buildOrdersList(context, state.orders);
            } else if (state is OrdersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<OrdersBloc>()
                            .add(LoadOrdersFromCheckout());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return _buildEmptyOrdersView(context);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyOrdersView(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.boxOpen,
            size: 50,
            color: AppColors.brandAccent,
          ),
          SizedBox(height: 20),
          Text('No orders yet',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<CompletedOrder> orders) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrdersBloc>().add(LoadOrdersFromCheckout());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text('Orders',
                  style: GoogleFonts.montaga(
                    textStyle: theme.textTheme.displayLarge?.copyWith(
                      color: isDarkMode
                          ? AppColors.cardColor
                          : AppColors.accentColorDark,
                    ),
                  )).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(6),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderItemWidget(order: order);
              },
            ),
          ),
        ],
      ),
    );
  }
}
