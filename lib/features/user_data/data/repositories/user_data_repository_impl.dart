import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/user_data/domain/entities/user_data.dart';
import 'package:chupachap/features/user_data/domain/repositories/user_data_repository.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  final AuthRepository _authRepository;

  UserDataRepositoryImpl({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

Future<String> _getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return 'Location access denied';
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Use high accuracy
      );

      // Get readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Extract locality and administrative area
        String locality = place.locality ?? 'Unknown Locality';
        String administrativeArea =
            place.administrativeArea ?? 'Unknown County';

        // Check if in Kenya
        if (place.country?.toLowerCase() == 'kenya') {
          return '$locality, $administrativeArea';
        } else {
          return 'You are outside Kenya';
        }
      }
      return 'Location not found';
    } catch (e) {
      print('Location error: $e');
      return 'Unable to fetch location';
    }
  }


@override
  Future<UserData> getUserData() async {
    final user = await _authRepository.getCurrentUserDetails();

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final location = await _getCurrentLocation();
    Position? position;

    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Use high accuracy
      );
    } catch (e) {
      print('Error getting position: $e');
    }

    return UserData(
      id: _authRepository.getCurrentUserId() ?? '',
      name: user.firstName,
      location: location,
      email: user.email,
      photoUrl: user.profileImage,
      latitude: position?.latitude,
      longitude: position?.longitude,
    );
  }
}
