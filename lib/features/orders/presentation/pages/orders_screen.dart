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

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<OrdersBloc>().add(LoadOrdersFromCheckout());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CompletedOrder> _filterOrders(
      List<CompletedOrder> orders, String status) {
    return orders
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          showCart: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Orders',
                style: GoogleFonts.montaga(
                  textStyle: theme.textTheme.displayLarge?.copyWith(
                    color: isDarkMode
                        ? AppColors.cardColor
                        : AppColors.accentColorDark,
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.cardColorDark
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? AppColors.shadowColorDark
                        : AppColors.shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.brandAccent
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
                labelStyle: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'pending'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Canceled'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersInitial) {
                    return const OrderShimmer();
                  } else if (state is OrdersEmpty) {
                    return _buildEmptyOrdersView(context);
                  } else if (state is OrdersLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrdersTab(
                          context,
                          _filterOrders(state.orders, 'pending'),
                          'pending',
                        ),
                        _buildOrdersTab(
                          context,
                          _filterOrders(state.orders, 'completed'),
                          'completed',
                        ),
                        _buildOrdersTab(
                          context,
                          _filterOrders(state.orders, 'canceled'),
                          'canceled',
                        ),
                      ],
                    );
                  } else if (state is OrdersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(state.message),
                          const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTab(
    BuildContext context,
    List<CompletedOrder> orders,
    String status,
  ) {
    if (orders.isEmpty) {
      return _buildEmptyTabView(context, status);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrdersBloc>().add(LoadOrdersFromCheckout());
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
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
    );
  }

  Widget _buildEmptyTabView(BuildContext context, String status) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    String message;
    String subtitle;
    IconData icon;

    switch (status) {
      case 'pending':
        message = 'No pending orders';
        subtitle = 'Orders being prepared will appear here';
        icon = FontAwesomeIcons.clock;
        break;
      case 'completed':
        message = 'No completed orders';
        subtitle = 'Your delivered orders will appear here';
        icon = FontAwesomeIcons.circleCheck;
        break;
      case 'canceled':
        message = 'No canceled orders';
        subtitle = 'Canceled orders will appear here';
        icon = FontAwesomeIcons.circleXmark;
        break;
      default:
        message = 'No orders';
        subtitle = 'Your orders will appear here';
        icon = FontAwesomeIcons.boxOpen;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: isDarkMode
                ? AppColors.brandAccent.withValues(alpha: 0.5)
                : AppColors.primaryColor.withValues(alpha: 0.5),
          )
              .animate()
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 800.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: 600.ms),
          const SizedBox(height: 24),
          Text(
            message,
            style: GoogleFonts.lato(
              textStyle: theme.textTheme.titleLarge,
              fontWeight: FontWeight.w600,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 800.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.lato(
              textStyle: theme.textTheme.bodyLarge?.copyWith(
                color: isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.5),
        ],
      ),
    );
  }

  Widget _buildEmptyOrdersView(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
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
}