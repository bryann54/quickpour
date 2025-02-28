import 'package:chupachap/features/wallet/data/models/transaction.dart';
import 'package:equatable/equatable.dart';
import 'payment_method.dart';

class Wallet extends Equatable {
  final List<PaymentMethod> paymentMethods;
  final double balance;
  final List<Transaction> transactions;

  const Wallet({
    required this.paymentMethods,
    required this.balance,
    required this.transactions,
  });

  factory Wallet.initial() {
    return const Wallet(
      paymentMethods: [],
      balance: 0.0,
      transactions: [],
    );
  }

  Wallet copyWith({
    List<PaymentMethod>? paymentMethods,
    double? balance,
    List<Transaction>? transactions,
  }) {
    return Wallet(
      paymentMethods: paymentMethods ?? this.paymentMethods,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentMethods': paymentMethods.map((pm) => pm.toJson()).toList(),
      'balance': balance,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      paymentMethods: (json['paymentMethods'] as List)
          .map((pm) => PaymentMethod.fromJson(pm))
          .toList(),
      balance: json['balance'],
      transactions: (json['transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [paymentMethods, balance, transactions];
}
