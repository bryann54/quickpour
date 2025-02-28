import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum PaymentMethodType { creditCard, debitCard }

class PaymentMethod extends Equatable {
  final String id;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final PaymentMethodType type;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.type,
    this.isDefault = false,
  });

  factory PaymentMethod.create({
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required String cvvCode,
    required PaymentMethodType type,
    bool isDefault = false,
  }) {
    return PaymentMethod(
      id: const Uuid().v4(),
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      type: type,
      isDefault: isDefault,
    );
  }

  PaymentMethod copyWith({
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    String? cvvCode,
    PaymentMethodType? type,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cvvCode: cvvCode ?? this.cvvCode,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'cvvCode': cvvCode,
      'type': type.toString(),
      'isDefault': isDefault,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      cardHolderName: json['cardHolderName'],
      cvvCode: json['cvvCode'],
      type: json['type'] == 'PaymentMethodType.creditCard'
          ? PaymentMethodType.creditCard
          : PaymentMethodType.debitCard,
      isDefault: json['isDefault'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        cardNumber,
        expiryDate,
        cardHolderName,
        cvvCode,
        type,
        isDefault,
      ];
}
