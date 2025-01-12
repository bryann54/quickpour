// data/models/drink_request.dart
class DrinkRequest {
  final String id;
  final String drinkName;
  final int quantity;
  final DateTime timestamp;
  final String merchantId; // Added field for the merchant
  final String additionalInstructions; // Added field for instructions
  final DateTime preferredTime; // Added field for preferred delivery time

  DrinkRequest({
    required this.id,
    required this.drinkName,
    required this.quantity,
    required this.timestamp,
    required this.merchantId,
    required this.additionalInstructions,
    required this.preferredTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'drinkName': drinkName,
      'quantity': quantity,
      'timestamp': timestamp.toIso8601String(),
      'merchantId': merchantId,
      'additionalInstructions': additionalInstructions,
      'preferredTime': preferredTime.toIso8601String(),
    };
  }

  factory DrinkRequest.fromMap(Map<String, dynamic> map) {
    return DrinkRequest(
      id: map['id'],
      drinkName: map['drinkName'],
      quantity: map['quantity'],
      timestamp: DateTime.parse(map['timestamp']),
      merchantId: map['merchantId'],
      additionalInstructions: map['additionalInstructions'],
      preferredTime: DateTime.parse(map['preferredTime']),
    );
  }
}
