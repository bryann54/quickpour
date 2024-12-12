import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CustomGreeting extends StatefulWidget {
  final String? userName;

  const CustomGreeting({Key? key, this.userName}) : super(key: key);

  @override
  _CustomGreetingState createState() => _CustomGreetingState();
}

class _CustomGreetingState extends State<CustomGreeting> {
  String _currentLocation = 'Fetching location...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 4) {
      return 'Good night';
    } else if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else if (hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentLocation = 'Location access denied';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Get readable address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentLocation =
              '${place.locality ?? place.subLocality ?? place.administrativeArea ?? 'Unknown'}, ${place.country ?? ''}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentLocation = 'Unable to fetch location';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme for dynamic styling
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child:
          _isLoading ? _buildLoadingState(theme) : _buildGreetingContent(theme),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Row(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(width: 16),
        Text(
          'Fetching location...',
          style: theme.textTheme.bodyMedium,
        )
      ],
    );
  }

  Widget _buildGreetingContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting with dynamic time-based message
        Text(
          '${_getGreeting()} 👋, ${widget.userName ?? 'User'}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
          ),
        ),
        // Location display with icon
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.locationDot,
              size: 15,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _currentLocation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
