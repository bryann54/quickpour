import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/checkout/presentation/pages/0rder_confirmation_screen.dart';
import 'package:flutter/material.dart';

class PaymentsScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentsScreen({super.key, required this.totalAmount});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.mpesa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showCart: false, showNotification: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _buildPaymentMethodTile(
              context,
              PaymentMethod.mpesa,
              'M-Pesa',
              'assets/M-PESA.png',
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodTile(
              context,
              PaymentMethod.cashOnDelivery,
              'Cash on Delivery',
              'assets/cod.png',
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodTile(
              context,
              PaymentMethod.creditCard,
              'Credit Card',
              'assets/code.png',
            ),
            const Spacer(),
            _buildTotalAmountWidget(),
            const SizedBox(height: 16),
            _buildProceedButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(BuildContext context, PaymentMethod method,
      String title, String iconPath) {
    final isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.white,
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 100,
              height: 60,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? AppColors.primaryColor : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            const Spacer(),
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedPaymentMethod,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Amount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'KSh ${widget.totalAmount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          _proceedWithPayment(context);
        },
        child: const Text(
          'Proceed to Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _proceedWithPayment(BuildContext context) {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.mpesa:
        _handleMpesaPayment();
        break;
      case PaymentMethod.cashOnDelivery:
        _handleCashOnDelivery();
        break;
      case PaymentMethod.creditCard:
        _handleCreditCardPayment();
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(
          orderId: '123456', // Replace with dynamic order ID
          totalAmount: widget.totalAmount,
          deliveryAddress: '123 Main Street, Nairobi',
          deliveryTime: 'Tomorrow, 2:00 PM',
        ),
      ),
    );
  }

  void _handleMpesaPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Initiating M-Pesa Payment')),
    );
  }

  void _handleCashOnDelivery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cash on Delivery Selected')),
    );
  }

  void _handleCreditCardPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Credit Card Payment Selected')),
    );
  }
}

enum PaymentMethod {
  mpesa,
  cashOnDelivery,
  creditCard,
}
