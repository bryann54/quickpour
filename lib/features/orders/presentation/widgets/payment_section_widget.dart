// widgets/delivery_payment_section.dart
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/card_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/info_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/section_widget.dart';
import 'package:flutter/material.dart';

class DeliveryPaymentSection extends StatelessWidget {
  final CompletedOrder order;

  const DeliveryPaymentSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Delivery & Payment'),
          InfoRow(label: 'Delivery Type', value: order.deliveryType),
          InfoRow(label: 'Delivery Address', value: order.address),
          InfoRow(label: 'Payment Method', value: order.paymentMethod),
          if (order.deliveryTime != 'Pickup')
            InfoRow(
              label: 'Delivery Window',
              value: order.deliveryTime,
              isLast: true,
            ),
        ],
      ),
    );
  }
}
