import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/pages/payments_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final String address;
  final String addressDetails;
  final LatLng location;
  final double totalAmount;
  final String phoneNumber;
  final String deliveryType;

  const DeliveryDetailsScreen({
    Key? key,
    required this.address,
    required this.addressDetails,
    required this.location,
    required this.totalAmount,
    required this.phoneNumber,
    required this.deliveryType,
  }) : super(key: key);

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  String? _selectedTimeSlot;
  String? _selectedDate;
  final TextEditingController _instructionsController = TextEditingController();

  bool _addressExpanded = true;
  bool _timeSlotExpanded = true;

  List<String> _availableDates = [];
  Map<String, List<String>> _timeSlots = {};

  @override
  void initState() {
    super.initState();
    _initializeDeliverySlots();
  }

  void _initializeDeliverySlots() {
    final now = DateTime.now();
    _availableDates = [];
    _timeSlots = {};

    // Generate dates for the next 7 days
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final dateStr = DateFormat('EEE, MMM d').format(date);
      _availableDates.add(dateStr);

      // Generate time slots for each date
      _timeSlots[dateStr] = _generateTimeSlotsForDate(date);
    }

    // Set default selected date to today
    _selectedDate = _availableDates[0];
  }

  List<String> _generateTimeSlotsForDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.day == now.day && date.month == now.month;
    final slots = <String>[];

    // For express delivery
    if (widget.deliveryType == 'express' && isToday) {
      // Generate 2-hour slots starting from current hour
      int currentHour = now.hour;
      for (int i = currentHour + 1; i < 24; i++) {
        final startTime = DateTime(date.year, date.month, date.day, i);
        final endTime = startTime.add(const Duration(hours: 2));
        final slot =
            '${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}';
        slots.add(slot);
      }
    }
    // For standard delivery
    else {
      // Generate 3-hour slots for the full day
      for (int i = 0; i < 24; i += 3) {
        if (!isToday || i > now.hour) {
          final startTime = DateTime(date.year, date.month, date.day, i);
          final endTime = startTime.add(const Duration(hours: 3));
          final slot =
              '${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}';
          slots.add(slot);
        }
      }
    }

    return slots;
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget content,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.withOpacity(.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, size: 24, color: theme.colorScheme.secondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: isExpanded ? 2 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimeSelector() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _availableDates.map((date) {
              final isSelected = date == _selectedDate;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    date,
                    style: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDate = date;
                        _selectedTimeSlot = null;
                      });
                    }
                  },
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor:
                      isDark ? theme.cardColor : theme.colorScheme.surface,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedDate != null)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeSlots[_selectedDate]!.map((slot) {
              final isSelected = slot == _selectedTimeSlot;
              return FilterChip(
                label: Text(
                  slot,
                  style: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onSecondary
                        : theme.colorScheme.onSurface,
                    fontSize: 13,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedTimeSlot = selected ? slot : null;
                  });
                },
                backgroundColor:
                    isDark ? theme.cardColor : theme.colorScheme.surface,
                selectedColor: theme.colorScheme.secondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Check if delivery is free
    final isFreeDelivery = widget.totalAmount >= 5000;
    final deliveryFee = isFreeDelivery
        ? 'Free'
        : (widget.deliveryType == 'express' ? 250.0 : 150.0);
    final total = isFreeDelivery
        ? widget.totalAmount
        : widget.totalAmount + (deliveryFee as double);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal', widget.totalAmount),
          const SizedBox(height: 8),
          _buildPriceRow(
            '${widget.deliveryType.capitalize()} Delivery',
            deliveryFee,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: theme.dividerColor),
          ),
          _buildPriceRow(
            'Total',
            total,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, dynamic value, {bool isTotal = false}) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium!.copyWith(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      fontSize: isTotal ? 16 : 14,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textStyle),
        Text(
          value is String ? value : '₦${value.toStringAsFixed(2)}',
          style: textStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.canvasColor : theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Delivery Details',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionCard(
                    title: 'Delivery Address',
                    icon: Icons.location_on,
                    isExpanded: _addressExpanded,
                    onToggle: () =>
                        setState(() => _addressExpanded = !_addressExpanded),
                    content: _buildAddressContent(),
                  ),
                  _buildSectionCard(
                    title: 'Delivery Window',
                    icon: Icons.access_time,
                    isExpanded: _timeSlotExpanded,
                    onToggle: () =>
                        setState(() => _timeSlotExpanded = !_timeSlotExpanded),
                    content: _buildDeliveryTimeSelector(),
                  ),
                  _buildInstructionsSection(),
                  const SizedBox(height: 24),
                  _buildPriceBreakdown(),
                ],
              ),
            ),
          ),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildAddressContent() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.address,
          style: theme.textTheme.bodyLarge,
        ),
        if (widget.addressDetails.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            widget.addressDetails,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.phone,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              widget.phoneNumber,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Instructions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _instructionsController,
            maxLines: 3,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Any special instructions for delivery...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              filled: true,
              fillColor: isDark
                  ? theme.colorScheme.surface
                  : theme.colorScheme.surface.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _selectedTimeSlot != null
            ? () {
                context.read<CheckoutBloc>().add(
                      UpdateDeliveryTimeEvent(
                        deliveryTime: '$_selectedDate, $_selectedTimeSlot',
                        specialInstructions: _instructionsController.text,
                      ),
                    );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentsScreen(
                      totalAmount: widget.totalAmount +
                          (widget.deliveryType == 'express' ? 250.0 : 150.0),
                      deliveryAddress: widget.address,
                      deliveryDetails: widget.addressDetails,
                      deliveryTime: '$_selectedDate, $_selectedTimeSlot',
                      specialInstructions: _instructionsController.text,
                      phoneNumber: widget.phoneNumber,
                      deliveryType: widget.deliveryType,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedTimeSlot != null
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: _selectedTimeSlot != null ? 4 : 0,
        ),
        child: Text(
          'Continue to Payment',
          style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _selectedTimeSlot != null
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(.3)),
        ),
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
