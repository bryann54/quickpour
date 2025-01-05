import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showCart: false,
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          // Load orders when the screen is built
          if (state is OrdersInitial) {
            context.read<OrdersBloc>().add(LoadOrdersFromCheckout());
          }

          if (state is OrdersEmpty) {
            return _buildEmptyOrdersView(context);
          }

          if (state is OrdersLoaded) {
            return _buildOrdersList(context, state.orders);
          }

          return const Center(child: CircularProgressIndicator());
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(order.date),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Delivery Address:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  order.address,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Payment Method:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  order.paymentMethod,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                if (order.items.isNotEmpty) ...[
                  Text(
                    'Items:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.quantity}x ${item.name}'),
                            Text(
                              'KSh ${(item.price * item.quantity).toStringAsFixed(0)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ],
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'KSh ${order.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
