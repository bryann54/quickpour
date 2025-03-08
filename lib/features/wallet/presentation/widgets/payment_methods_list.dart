import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/wallet/data/models/payment_method.dart';
import 'package:flutter/material.dart';

class PaymentMethodsList extends StatelessWidget {
  final List<PaymentMethod> paymentMethods;
  final Function(String) onSetDefault;
  final Function(String) onRemove;
  final Function(String) onAddFunds;

  const PaymentMethodsList({
    Key? key,
    required this.paymentMethods,
    required this.onSetDefault,
    required this.onRemove,
    required this.onAddFunds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (paymentMethods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(
              Icons.credit_card_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No payment methods added',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        final card = paymentMethods[index];
        final lastFourDigits = card.cardNumber
            .replaceAll(' ', '')
            .substring(card.cardNumber.replaceAll(' ', '').length - 4);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: card.isDefault
                ? BorderSide(
                    color: AppColors.primaryColor.withOpacity(.5), width: 2)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.brandPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        color: AppColors.brandPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                card.type == PaymentMethodType.creditCard
                                    ? 'Credit Card'
                                    : 'Debit Card',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (card.isDefault)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Default',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'xxxx xxxx xxxx $lastFourDigits',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Expires: ${card.expiryDate}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'set_default') {
                          onSetDefault(card.id);
                        } else if (value == 'remove') {
                          onRemove(card.id);
                        } else if (value == 'add_funds') {
                          onAddFunds(card.id);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        if (!card.isDefault)
                          const PopupMenuItem<String>(
                            value: 'set_default',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, size: 18),
                                SizedBox(width: 8),
                                Text('Set as Default'),
                              ],
                            ),
                          ),
                        const PopupMenuItem<String>(
                          value: 'add_funds',
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline, size: 18),
                              SizedBox(width: 8),
                              Text('Add Funds'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline,
                                  size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
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
