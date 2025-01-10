import 'dart:async';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_state.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/pages/0rder_confirmation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsScreen extends StatefulWidget {
  final double totalAmount;
  final String deliveryAddress;
  final String deliveryDetails;
  final String deliveryTime;
  final String specialInstructions;

  const PaymentsScreen({
    Key? key,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.deliveryDetails,
    required this.deliveryTime,
    required this.specialInstructions,
  }) : super(key: key);

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final TextEditingController _phoneController = TextEditingController();
  late final AuthBloc _authBloc;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.mpesa;
  StreamSubscription? _checkoutSubscription;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _checkAuthentication();
  }

  @override
  void dispose() {
    _checkoutSubscription?.cancel();
    super.dispose();
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
    return Scaffold(
      appBar: CustomAppBar(showCart: false, showNotification: false),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutOrderPlacedState) {
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
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
            
              const SizedBox(height: 24),
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
      ),
    );
  }

  Widget _buildPaymentMethodTile(
    BuildContext context,
    PaymentMethod method,
    String title,
    String iconPath,
  ) {
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
        onPressed: () {
        

          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please log in to place an order'),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.of(context).pushReplacementNamed('/login');
            return;
          }

          try {
            final cartBloc = context.read<CartBloc>();
            final cart = cartBloc.state.cart;
            final checkoutBloc = context.read<CheckoutBloc>();

            // Update delivery info with phone number
            checkoutBloc.add(UpdateDeliveryInfoEvent(
              address: "${widget.deliveryAddress}\n${widget.deliveryDetails}",
              phoneNumber: _phoneController.text,
            ));

            // Update payment method
            checkoutBloc.add(UpdatePaymentMethodEvent(
              paymentMethod: _selectedPaymentMethod.toString().split('.').last,
            ));

            // Place order
            checkoutBloc.add(PlaceOrderEvent(
              cart: cart,
              deliveryTime: widget.deliveryTime,
              specialInstructions: widget.specialInstructions,
              paymentMethod: _selectedPaymentMethod.toString().split('.').last,
            ));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Place Order'),
      ),
    );
  }

  void _proceedWithPayment(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to place an order'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

   

    try {
      final cartBloc = context.read<CartBloc>();
      final cart = cartBloc.state.cart;
      final checkoutBloc = context.read<CheckoutBloc>();

      // Update delivery info with phone number
      checkoutBloc.add(UpdateDeliveryInfoEvent(
        address: "${widget.deliveryAddress}\n${widget.deliveryDetails}",
        phoneNumber: _phoneController.text,
      ));

      // Update payment method
      checkoutBloc.add(UpdatePaymentMethodEvent(
        paymentMethod: _selectedPaymentMethod.toString().split('.').last,
      ));

      // Place order
      checkoutBloc.add(PlaceOrderEvent(
        cart: cart,
        deliveryTime: widget.deliveryTime,
        specialInstructions: widget.specialInstructions,
        paymentMethod: _selectedPaymentMethod.toString().split('.').last,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

enum PaymentMethod {
  mpesa,
  cashOnDelivery,
  creditCard,
}
