import 'package:chupachap/features/checkout/data/models/delivery_details_model.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:chupachap/features/checkout/presentation/pages/delivery_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryLocationScreen extends StatefulWidget {
  final double totalAmount;
  final DeliveryDetails location;
  final String phoneNumber;

  const DeliveryLocationScreen({
    Key? key,
    required this.totalAmount,
    required this.location,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<DeliveryLocationScreen> createState() => _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState extends State<DeliveryLocationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _addressDetailsController =
      TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _currentAddress;
  bool _isLoading = true;
  String _deliveryType = '';

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _addressDetailsController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      setState(() {
        _selectedLocation = LatLng(
          widget.location.latitude,
          widget.location.longitude,
        );
        _currentAddress = widget.location.address;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              '${place.street}, ${place.subLocality}, ${place.locality}';
        });
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
  }

  Widget _buildMapSection() {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation ?? const LatLng(0, 0),
                zoom: 14,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: (position) => _selectedLocation = position.target,
              onCameraIdle: () {
                if (_selectedLocation != null) {
                  _getAddressFromLatLng(_selectedLocation!);
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
            ),
            if (_isLoading)
              Container(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTypeSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Type',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            children: [
              _buildDeliveryOption(
                'express',
                'Express Delivery',
                'Priority delivery',
                Icons.rocket_launch_outlined,
              ),
              const SizedBox(height: 5),
              _buildDeliveryOption(
                'standard',
                'Standard Delivery',
                '2-3 hours',
                Icons.local_shipping_outlined,
              ),
              const SizedBox(height: 5),
              _buildDeliveryOption(
                'pickup',
                'Pick Up',
                'Pick the order yourself',
                Icons.store_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _deliveryType == value;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: .3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _deliveryType = value),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .secondaryFixed
                      .withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: .7)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? isDark
                          ? Colors.amber
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? isDark
                                  ? Colors.amber
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? isDark
                                  ? Colors.amber
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6)
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: value,
                  groupValue: _deliveryType,
                  onChanged: (value) => setState(() => _deliveryType = value!),
                  activeColor:
                      isDark ? Colors.white : theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressDetailsSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (_currentAddress != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              _currentAddress!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        TextField(
          controller: _addressDetailsController,
          maxLines: 3,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Apartment, Floor, Landmark etc.',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: isDark
                ? theme.colorScheme.surface
                : theme.colorScheme.surface.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2.0, // More distinct border when focused
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                width: 1.2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? theme.colorScheme.surface : theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Delivery Type',
          style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMapSection(),
                        const SizedBox(height: 14),
                        _buildDeliveryTypeSection(),
                        const SizedBox(height: 14),
                        _buildAddressDetailsSection(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed:
                        (_selectedLocation != null && _deliveryType.isNotEmpty)
                            ? () {
                                context.read<CheckoutBloc>().add(
                                      UpdateDeliveryInfoEvent(
                                        address:
                                            '${_currentAddress ?? ''}\n${_addressDetailsController.text}',
                                        phoneNumber: widget.phoneNumber,
                                        deliveryType: _deliveryType,
                                      ),
                                    );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DeliveryDetailsScreen(
                                      address: _currentAddress ?? '',
                                      addressDetails:
                                          _addressDetailsController.text,
                                      location: _selectedLocation!,
                                      totalAmount: widget.totalAmount,
                                      phoneNumber: widget.phoneNumber,
                                      deliveryType: _deliveryType,
                                    ),
                                  ),
                                );
                              }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_selectedLocation != null &&
                              _deliveryType.isNotEmpty)
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: (_selectedLocation != null &&
                              _deliveryType.isNotEmpty)
                          ? 4
                          : 0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Confirm delivery type',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: (_selectedLocation != null &&
                                      _deliveryType.isNotEmpty)
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Icon(
                            Icons.arrow_forward,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
