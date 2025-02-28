import 'package:chupachap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_state.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:chupachap/features/checkout/presentation/pages/0rder_confirmation_screen.dart';
import 'package:chupachap/features/checkout/presentation/widgets/order_summary_card.dart';
import 'package:chupachap/features/checkout/presentation/widgets/payment_bottom_bar.dart';
import 'package:chupachap/features/checkout/presentation/widgets/payment_method_selector.dart';
import 'package:chupachap/features/wallet/data/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PaymentMethod { mpesa, cashOnDelivery, creditCard, wallet }

extension PaymentMethodMapper on PaymentMethod {
  CheckoutPaymentMethod toCheckoutPaymentMethod() {
    switch (this) {
      case PaymentMethod.mpesa:
        return CheckoutPaymentMethod.mpesa;
      case PaymentMethod.cashOnDelivery:
        return CheckoutPaymentMethod.cashOnDelivery;
      case PaymentMethod.creditCard:
        return CheckoutPaymentMethod.creditCard;
      case PaymentMethod.wallet:
        return CheckoutPaymentMethod.wallet;
    }
  }
}

extension CheckoutPaymentMethodMapper on CheckoutPaymentMethod {
  PaymentMethod toPaymentMethod() {
    switch (this) {
      case CheckoutPaymentMethod.mpesa:
        return PaymentMethod.mpesa;
      case CheckoutPaymentMethod.cashOnDelivery:
        return PaymentMethod.cashOnDelivery;
      case CheckoutPaymentMethod.creditCard:
        return PaymentMethod.creditCard;
      case CheckoutPaymentMethod.wallet:
        return PaymentMethod.wallet;
    }
  }
}

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
  double _walletBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _checkAuthentication();
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    final walletRepository = WalletRepository();
    final wallet = await walletRepository.getWallet();
    setState(() {
      _walletBalance = wallet.balance;
    });
  }

  void _checkAuthentication() {
    if (_authBloc.state is! Authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  void _handlePlaceOrder() {
    if (_isLoading) return;
    if (_selectedPaymentMethod == PaymentMethod.wallet &&
        _walletBalance < widget.totalAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Insufficient wallet balance."),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Payment Method"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutOrderPlacedState) {
            context.read<CartBloc>().add(ClearCartEvent());
            _fetchWalletBalance(); // Fetch updated wallet balance
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
                  backgroundColor: Colors.red[400]),
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
                      OrderSummaryCard(
                        deliveryTime: widget.deliveryTime,
                        deliveryType: widget.deliveryType,
                        totalAmount: widget.totalAmount,
                      ),
                      const SizedBox(height: 24),
                      PaymentMethodSelector(
                        selectedMethod:
                            _selectedPaymentMethod.toCheckoutPaymentMethod(),
                        onMethodChanged: (method) => setState(() =>
                            _selectedPaymentMethod = method.toPaymentMethod()),
                        walletBalance: _walletBalance,
                        orderTotal: widget.totalAmount,
                      ),
                    ],
                  ),
                ),
              ),
              PaymentBottomBar(
                totalAmount: widget.totalAmount,
                isLoading: _isLoading,
                onPayPressed: _handlePlaceOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
