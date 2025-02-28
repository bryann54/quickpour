import 'package:chupachap/features/wallet/data/models/payment_method.dart';
import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class WalletLoaded extends WalletEvent {
  const WalletLoaded();
}

class AddPaymentMethodEvent extends WalletEvent {
  final PaymentMethod paymentMethod;

  const AddPaymentMethodEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class RemovePaymentMethodEvent extends WalletEvent {
  final String paymentMethodId;

  const RemovePaymentMethodEvent(this.paymentMethodId);

  @override
  List<Object?> get props => [paymentMethodId];
}

class SetDefaultPaymentMethodEvent extends WalletEvent {
  final String paymentMethodId;

  const SetDefaultPaymentMethodEvent(this.paymentMethodId);

  @override
  List<Object?> get props => [paymentMethodId];
}

class AddFundsEvent extends WalletEvent {
  final double amount;
  final String paymentMethodId;

  const AddFundsEvent(this.amount, this.paymentMethodId);

  @override
  List<Object?> get props => [amount, paymentMethodId];
}

class MakePaymentEvent extends WalletEvent {
  final double amount;
  final String description;

  const MakePaymentEvent(this.amount, this.description);

  @override
  List<Object?> get props => [amount, description];
}
