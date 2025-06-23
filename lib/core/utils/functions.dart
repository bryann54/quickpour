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
