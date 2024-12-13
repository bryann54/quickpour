import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {

  final LatLng _initialLocation =
      LatLng(37.7749, -122.4194); // Example: San Francisco
  final LatLng _destination =
      LatLng(34.0522, -118.2437); // Example: Los Angeles

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 10.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('start'),
            position: _initialLocation,
            infoWindow: InfoWindow(title: 'Start Location'),
          ),
          Marker(
            markerId: MarkerId('destination'),
            position: _destination,
            infoWindow: InfoWindow(title: 'Destination'),
          ),
        },
        onMapCreated: (controller) {
        },
      ),
    );
  }
}
