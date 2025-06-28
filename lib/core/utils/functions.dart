import 'package:chupachap/features/promotions/data/models/promotion_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

//time formatter
String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else {
    return DateFormat('MMM d, HH:mm').format(timestamp);
  }
}

// common/enums/order_status.dart
enum OrderStatus {
  received,
  processing,
  dispatched,
  delivering,
  completed,
  canceled,
}

OrderStatus getOrderStatus(String status) {
  switch (status.toLowerCase()) {
    case 'received':
      return OrderStatus.received;
    case 'processing':
      return OrderStatus.processing;
    case 'dispatched':
      return OrderStatus.dispatched;
    case 'delivering':
      return OrderStatus.delivering;
    case 'completed':
      return OrderStatus.completed;
    default:
      return OrderStatus.received;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// Helper function to get the appropriate delivery typeicon
IconData getDeliveryIcon(String deliveryType) {
  switch (deliveryType) {
    case 'express':
      return Icons.rocket_launch_outlined;
    case 'standard':
      return Icons.local_shipping_outlined;
    case 'pickup':
      return Icons.storefront_outlined;
    default:
      return Icons.help_outline;
  }
}

String getDeliveryText(String deliveryType) {
  switch (deliveryType) {
    case 'express':
      return 'Express Delivery';
    case 'standard':
      return 'Standard Delivery';
    case 'pickup':
      return 'Store Pickup';
    default:
      return 'Standard Delivery';
  }
}

String formatMoney(num amount) {
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(amount);
}

int calculateDiscountPercentage(double originalPrice, double discountPrice) {
  if (originalPrice <= 0 || discountPrice <= 0) {
    return 0; // Handle invalid values gracefully
  }
  final discount = ((originalPrice - discountPrice) / originalPrice) * 100;
  return discount.round(); // Return rounded discount percentage
}

String formatDate(DateTime date) {
  return '${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
}

String getPromotionTypeDisplay(PromotionTarget target) {
  switch (target) {
    case PromotionTarget.products:
      return 'Specific Products';
    case PromotionTarget.categories:
      return 'Product Categories';
    case PromotionTarget.brands:
      return 'Product Brands';
  }
}

String getValidityPeriod(PromotionModel promotion) {
  return 'Valid until ${formatDate(promotion.endDate)}';
}

class OrderStatusUtils {
  static Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.canceled:
        return const Color.fromARGB(255, 15, 5, 68);
      case OrderStatus.received:
        return const Color(0xFFF39C12);
      case OrderStatus.processing:
        return const Color(0xFF3498DB);
      case OrderStatus.dispatched:
        return const Color(0xFF9B59B6);
      case OrderStatus.delivering:
        return const Color(0xFF1ABC9C);
      case OrderStatus.completed:
        return const Color(0xFF2ECC71);
    }
  }

  static IconData getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.received:
        return Icons.assignment;
      case OrderStatus.processing:
        return Icons.build;
      case OrderStatus.dispatched:
        return FontAwesomeIcons.box;
      case OrderStatus.delivering:
        return Icons.local_shipping;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.canceled:
        return Icons.cancel;
    }
  }

  static String getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.received:
        return 'Received';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.dispatched:
        return 'Ready to Ship';
      case OrderStatus.delivering:
        return 'Shipping';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.canceled:
        return 'Canceled';
    }
  }
}

String extractMainText(String? formattedAddress) {
  if (formattedAddress == null) return '';
  return formattedAddress.split(',').first.trim();
}

String extractSecondaryText(String? formattedAddress, String? name) {
  if (formattedAddress == null) return '';
  final parts = formattedAddress.split(',');
  if (parts.length > 1) {
    final secondary = parts.skip(1).join(',').trim();
    // Remove the name from secondary text to avoid duplication
    if (name != null && secondary.startsWith(name)) {
      return secondary.substring(name.length).replaceFirst(',', '').trim();
    }
    return secondary;
  }
  return '';
}

String extractCity(String? formattedAddress) {
  if (formattedAddress == null) return '';
  // Simple extraction - you might want to make this more sophisticated
  final parts = formattedAddress.split(',');
  for (var part in parts.reversed) {
    part = part.trim();
    if (part.isNotEmpty && !part.contains('Kenya') && part.length > 2) {
      return part;
    }
  }
  return '';
}

String getPlaceType(List<String> types) {
  // Prioritize residential and delivery-relevant places
  if (types.contains('street_address')) return 'address';
  if (types.contains('subpremise')) return 'apartment';
  if (types.contains('premise')) return 'building';
  if (types.contains('establishment')) return 'establishment';
  if (types.contains('lodging')) return 'hotel';
  if (types.contains('point_of_interest')) return 'poi';
  if (types.contains('route')) return 'route';
  if (types.contains('intersection')) return 'intersection';
  if (types.contains('plus_code')) return 'plus_code';
  return 'location';
}

String getPlaceTypeLabel(String placeType) {
  switch (placeType) {
    case 'apartment':
      return 'Apartment';
    case 'building':
      return 'Building';
    case 'premise':
      return 'Property';
    case 'establishment':
      return 'Business';
    case 'poi':
      return 'Landmark';
    case 'route':
      return 'Road';
    case 'address':
      return 'Address';
    case 'current_location':
      return 'Current Location';
    default:
      return 'Location';
  }
}

IconData getIconForPlaceType(List<String> types) {
  // Residential locations
  if (types.contains('apartment') ||
      types.contains('subpremise') ||
      types.contains('premise')) {
    return FontAwesomeIcons.buildingUser;
  }

  // Delivery-friendly businesses
  if (types.contains('restaurant') ||
      types.contains('food') ||
      types.contains('meal_takeaway') ||
      types.contains('bar') ||
      types.contains('night_club')) {
    return FontAwesomeIcons.wineGlass;
  }

  // Common delivery locations
  if (types.contains('hotel') || types.contains('lodging')) {
    return FontAwesomeIcons.hotel;
  }
  if (types.contains('office') || types.contains('workplace')) {
    return FontAwesomeIcons.building;
  }
  if (types.contains('university') || types.contains('school')) {
    return FontAwesomeIcons.graduationCap;
  }

  // Default icons for other types
  if (types.contains('establishment')) return FontAwesomeIcons.store;
  if (types.contains('point_of_interest')) return FontAwesomeIcons.mapPin;
  if (types.contains('route')) return FontAwesomeIcons.route;

  return FontAwesomeIcons.locationDot;
}
