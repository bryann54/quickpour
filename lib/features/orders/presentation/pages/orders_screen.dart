import 'dart:math';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      appBar: CustomAppBar(
        showCart: false,
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersInitial) {
            return const Center(
              child: CircularProgressIndicator(),
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
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrdersBloc>().add(LoadOrdersFromCheckout());
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
  return RefreshIndicator(
    onRefresh: () async {
      context.read<OrdersBloc>().add(LoadOrdersFromCheckout());
    },
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderItemWidget(order: order); // Use the OrderItemWidget here
      },
    ),
  );
}
}