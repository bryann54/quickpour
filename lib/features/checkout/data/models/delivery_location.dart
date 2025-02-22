class DeliveryLocation {
  final String address;
  final double latitude;
  final double longitude;
  final String mainText;
  final String secondaryText;

  DeliveryLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.mainText,
    required this.secondaryText,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'mainText': mainText,
        'secondaryText': secondaryText,
      };

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) =>
      DeliveryLocation(
        address: json['address'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        mainText: json['mainText'],
        secondaryText: json['secondaryText'],
      );
}
