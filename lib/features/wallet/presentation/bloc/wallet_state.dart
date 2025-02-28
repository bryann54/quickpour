import 'package:chupachap/features/wallet/data/models/payment_method.dart';
import 'package:chupachap/features/wallet/data/models/wallet.dart';
import 'package:equatable/equatable.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final Wallet wallet;

  const WalletLoaded(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

// Add these to your wallet_state.dart file
class OrderPaymentSuccess extends WalletState {
  final Wallet wallet;
  final double amount;
  final PaymentMethod paymentMethod;

  const OrderPaymentSuccess(this.wallet, this.amount, this.paymentMethod);

  @override
  List<Object?> get props => [wallet, amount, paymentMethod];
}

class OrderPaymentFailure extends WalletState {
  final String message;

  const OrderPaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentMethodAdded extends WalletState {
  final Wallet wallet;

  const PaymentMethodAdded(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class PaymentMethodRemoved extends WalletState {
  final Wallet wallet;

  const PaymentMethodRemoved(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class DefaultPaymentMethodSet extends WalletState {
  final Wallet wallet;

  const DefaultPaymentMethodSet(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class FundsAdded extends WalletState {
  final Wallet wallet;
  final double amount;

  const FundsAdded(this.wallet, this.amount);

  @override
  List<Object?> get props => [wallet, amount];
}

class PaymentSuccess extends WalletState {
  final Wallet wallet;
  final double amount;

  const PaymentSuccess(this.wallet, this.amount);

  @override
  List<Object?> get props => [wallet, amount];
}

class PaymentFailure extends WalletState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
