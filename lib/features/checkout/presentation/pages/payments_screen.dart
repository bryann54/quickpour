import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_state.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/pages/0rder_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PaymentMethod { mpesa, cashOnDelivery, creditCard }

class PaymentsScreen extends StatefulWidget {
  final double totalAmount;
  final String deliveryAddress;
  final String deliveryDetails;
  final String deliveryTime;
  final String specialInstructions;
  final String phoneNumber;
  final String deliveryType;

  const PaymentsScreen({
    Key? key,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.deliveryDetails,
    required this.deliveryTime,
    required this.specialInstructions,
    required this.phoneNumber,
    required this.deliveryType,
  }) : super(key: key);

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late final AuthBloc _authBloc;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.mpesa;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _checkAuthentication();
  }

  void _checkAuthentication() {
    if (_authBloc.state is! Authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Payment Method',
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutOrderPlacedState) {
            context.read<CartBloc>().add(ClearCartEvent());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrderConfirmationScreen(
                  orderId: state.orderId,
                  totalAmount: widget.totalAmount,
                  deliveryAddress: widget.deliveryAddress,
                  deliveryTime: widget.deliveryTime,
                  selectedPaymentMethod:
                      _selectedPaymentMethod.toString().split('.').last,
                ),
              ),
            );
          } else if (state is CheckoutErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red[400],
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            setState(() => _isLoading = false);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderSummary(),
                      const SizedBox(height: 24),
                      Text(
                        'Select Payment Method',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPaymentMethods(),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.background.withOpacity(.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Delivery Time', widget.deliveryTime),
          _buildSummaryRow('Delivery Type', widget.deliveryType),
          Divider(
            height: 24,
            color: theme.dividerColor,
          ),
          _buildSummaryRow(
            'Total Amount',
            'KSh ${widget.totalAmount.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal
                  ? (isDark
                      ? theme.colorScheme.onSurface.withOpacity(.7)
                      : AppColors.primaryColor)
                  : theme.textTheme.bodyLarge?.color,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(
    PaymentMethod method,
    String title,
    String iconPath,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedPaymentMethod == method;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? (isDark
                  ? AppColors.error.withOpacity(.1)
                  : AppColors.primaryColor)
              : theme.dividerColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: isSelected
            ? AppColors.background.withOpacity(.1)
            : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _selectedPaymentMethod = method),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    iconPath,
                    width: 60,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Radio<PaymentMethod>(
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) =>
                      setState(() => _selectedPaymentMethod = value!),
                  activeColor:
                      isDark ? Colors.white : theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentMethodTile(
          PaymentMethod.mpesa,
          'M-Pesa',
          'assets/M-PESA.png',
          'Pay securely with M-Pesa',
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodTile(
          PaymentMethod.cashOnDelivery,
          'Cash on Delivery',
          'assets/cod.png',
          'Pay when you receive your order',
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodTile(
          PaymentMethod.creditCard,
          'Credit Card',
          'assets/card.png',
          'Pay with Visa or Mastercard',
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _isLoading ? null : () => _handlePlaceOrder(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pay KSh ${widget.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
        ),
      ),
    );
  }

  void _handlePlaceOrder(BuildContext context) {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final cartBloc = context.read<CartBloc>();
    final cart = cartBloc.state.cart;

    context.read<CheckoutBloc>().add(
          PlaceOrderEvent(
            cart: cart,
            deliveryTime: widget.deliveryTime,
            specialInstructions: widget.specialInstructions,
            paymentMethod: _selectedPaymentMethod.toString().split('.').last,
            address: widget.deliveryAddress,
            phoneNumber: widget.phoneNumber,
            deliveryType: widget.deliveryType,
          ),
        );
  }
}
