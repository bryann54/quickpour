import 'package:equatable/equatable.dart';

class DeliveryDetails extends Equatable {
  final String address;
  final double latitude;
  final double longitude;
  final String mainText;
  final String secondaryText;
  final String phoneNumber;

  const DeliveryDetails({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.mainText,
    required this.secondaryText,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'mainText': mainText,
        'secondaryText': secondaryText,
        'phoneNumber': phoneNumber,
      };

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) =>
      DeliveryDetails(
        address: json['address'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        mainText: json['mainText'],
        secondaryText: json['secondaryText'],
        phoneNumber: json['phoneNumber'] ?? '',
      );

  @override
  List<Object?> get props => [
        address,
        latitude,
        longitude,
        mainText,
        secondaryText,
        phoneNumber,
      ];
}
