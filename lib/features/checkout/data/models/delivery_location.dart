class DeliveryLocation {
  final String address;
  final double latitude;
  final double longitude;
  final String? placeId;
  final String? mainText;
  final String? secondaryText;

  DeliveryLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.placeId,
    this.mainText,
    this.secondaryText,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'placeId': placeId,
        'mainText': mainText,
        'secondaryText': secondaryText,
      };
}
