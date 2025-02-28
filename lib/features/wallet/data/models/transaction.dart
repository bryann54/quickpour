import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { deposit, withdrawal, payment }

class Transaction extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String description;
  final String? paymentMethodId;

  const Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.description,
    this.paymentMethodId,
  });

  factory Transaction.create({
    required double amount,
    required TransactionType type,
    required String description,
    String? paymentMethodId,
  }) {
    return Transaction(
      id: const Uuid().v4(),
      amount: amount,
      date: DateTime.now(),
      type: type,
      description: description,
      paymentMethodId: paymentMethodId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'description': description,
      'paymentMethodId': paymentMethodId,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      type: _getTransactionTypeFromString(json['type']),
      description: json['description'],
      paymentMethodId: json['paymentMethodId'],
    );
  }

  static TransactionType _getTransactionTypeFromString(String typeStr) {
    if (typeStr.contains('deposit')) return TransactionType.deposit;
    if (typeStr.contains('withdrawal')) return TransactionType.withdrawal;
    return TransactionType.payment;
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        date,
        type,
        description,
        paymentMethodId,
      ];
}
