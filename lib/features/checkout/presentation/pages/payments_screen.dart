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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _checkAuthentication();
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
      appBar: AppBar(
        title: const Text('Payments'),
        centerTitle: true,
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
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
        onPressed: _isLoading ? null : () => _handlePlaceOrder(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Text('Place Order'),
      ),
    );
  }

  void _handlePlaceOrder(BuildContext context) {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final checkoutBloc = context.read<CheckoutBloc>();
    final cartBloc = context.read<CartBloc>();
    final cart = cartBloc.state.cart;

    // Dispatch PlaceOrderEvent with all required data
    checkoutBloc.add(PlaceOrderEvent(
      cart: cart,
      deliveryTime: widget.deliveryTime,
      specialInstructions: widget.specialInstructions,
      paymentMethod: _selectedPaymentMethod.toString().split('.').last,
      address: widget.deliveryAddress, // Pass address
      phoneNumber: _phoneController.text, // Pass phone number
    ));
  }
}
