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
  void initState() {
    super.initState();
    // Load orders when screen initializes
    context.read<OrdersBloc>().add(LoadOrdersFromCheckout());
  }

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Fix: Removed the Expanded widget that was causing the error
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating box animation background
          ...List.generate(15, (index) {
            final isSmall = index % 2 == 0;
            final xOffset = (index * 25 - 120).toDouble();
            final startY = index * 35 - 180.0;

            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + xOffset,
              top: startY,
              child: Icon(
                FontAwesomeIcons.boxOpen,
                color: isDarkMode
                    ? AppColors.brandAccent
                        .withValues(alpha: 0.5 + (index % 5) * 0.1)
                    : AppColors.accentColor
                        .withValues(alpha: 0.5 + (index % 5) * 0.1),
                size: isSmall ? 16.0 : 24.0,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .moveY(
                    begin: 0,
                    end: 500,
                    duration: Duration(
                        seconds: isSmall ? 6 + index % 4 : 8 + index % 5),
                    curve: Curves.easeInOut,
                  )
                  .fadeIn(duration: 600.ms)
                  .then()
                  .fadeOut(
                    begin: 0.7,
                    delay: Duration(
                        seconds: isSmall ? 5 + index % 3 : 7 + index % 4),
                  ),
            );
          }),

          // Main content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/orders.png',
                width: 150,
                height: 150,
              ).animate().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 20),

              // Text message with animations
              Text(
                'No orders yet!',
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.titleLarge),
              ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut),

              const SizedBox(height: 10),

              Text(
                'Your order history will appear here',
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.bodyLarge),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.5, duration: 800.ms),
            ],
          ),
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
            padding: const EdgeInsets.all(2.0),
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
              // padding: const EdgeInsets.symmetric(horizontal: 2),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderItemWidget(order: order)
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: Duration(milliseconds: index * 50),
                    )
                    .slideY(begin: 0.1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
