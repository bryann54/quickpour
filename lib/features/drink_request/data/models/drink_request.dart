class DrinkRequest {
  final String id;
  final String drinkName;
  final String userId; // Add userId field
  final int quantity;
  final DateTime timestamp;
  final String merchantId;
  final String additionalInstructions;
  final DateTime preferredTime;

  DrinkRequest({
    required this.id,
    required this.drinkName,
    required this.userId, // Add to constructor
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
      'userId': userId, // Add to map
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
      userId: map['userId'], // Add to fromMap
      quantity: map['quantity'],
      timestamp: DateTime.parse(map['timestamp']),
      merchantId: map['merchantId'],
      additionalInstructions: map['additionalInstructions'],
      preferredTime: DateTime.parse(map['preferredTime']),
    );
  }
}
