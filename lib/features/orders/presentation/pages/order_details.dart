// order_details_page.dart
import 'package:chupachap/features/orders/presentation/widgets/customer_details_section.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_header_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_item_section.dart';
import 'package:chupachap/features/orders/presentation/widgets/payment_section_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/widgets/share_button.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';

class OrderDetails extends StatelessWidget {
  final CompletedOrder order;

  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      // appBar: CustomAppBar(showCart: false),
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Details',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            ShareButton(order: order,),
       
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeader(order: order),
            const SizedBox(height: 16),
            OrderItemsSection(order: order),
            const SizedBox(height: 16),
            DeliveryPaymentSection(order: order),
            const SizedBox(height: 16),
            CustomerDetailsSection(order: order),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
