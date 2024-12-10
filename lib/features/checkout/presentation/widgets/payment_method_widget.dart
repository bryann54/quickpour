import 'package:flutter/material.dart';

class PaymentMethodSection extends StatelessWidget {
  final bool isDarkMode;
  final String? paymentMethod;
  final ValueChanged<String?> onPaymentMethodChanged; // Updated type

  const PaymentMethodSection({
    required this.isDarkMode,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Payment Method'),
        Card(
          elevation: 2,
          child: Column(
            children: [
              _buildPaymentOption('M-Pesa', 'assets/M-PESA.png'),
              _buildPaymentOption('Cash on Delivery', 'code.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String title, String assetPath) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Image.asset(assetPath, height: 40, width: 100),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      value: title,
      groupValue: paymentMethod,
      onChanged: onPaymentMethodChanged, // No changes needed here
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
