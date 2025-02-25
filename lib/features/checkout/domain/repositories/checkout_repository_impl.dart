import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/checkout/domain/entities/merchant_order.dart';
import 'package:chupachap/features/checkout/domain/entities/order.dart'
    as app_order;
import 'package:chupachap/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:chupachap/features/notifications/domain/repositories/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final FirebaseFirestore firestore;
  final AuthUseCases authUseCases;

  CheckoutRepositoryImpl({
    required this.firestore,
    required this.authUseCases,
  });

  @override
  Future<app_order.Order> placeOrder({
    required Cart cart,
    required String deliveryTime,
    required String specialInstructions,
    required String paymentMethod,
    required String address,
    required String phoneNumber,
    required String deliveryType,
  }) async {
    // Check user authentication
    final userId = authUseCases.getCurrentUserId();
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Get user details
    final userDetails = await authUseCases.getCurrentUserDetails();
    if (userDetails == null) {
      throw Exception('User details not found');
    }

    // Generate orderId using actual document reference
    final orderRef = firestore.collection('orders').doc();
    final orderId = orderRef.id;
    final now = DateTime.now();

    // Group cart items by merchant
    final merchantItemsMap = <String, List<CartItem>>{};
    for (final item in cart.items) {
      final merchantId = item.product.merchantId;
      merchantItemsMap.putIfAbsent(merchantId, () => []).add(item);
    }

    // Create merchant orders
  // Modify your method where you create merchant orders
    final merchantOrders = merchantItemsMap.entries
        .map((entry) {
          final merchantId = entry.key;
          final items = entry.value;

          // Skip if there are no items for this merchant
          if (items.isEmpty) {
            return null;
          }

          final firstItem = items.first;

          // Ensure all required fields have at least default values
          final merchantName = firstItem.product.merchantName.isNotEmpty
              ? firstItem.product.merchantName
              : "Unknown Merchant";

          // Calculate subtotal for this merchant
          final subtotal = items.fold<double>(
              0, (sum, item) => sum + (item.quantity * item.product.price));

          return MerchantOrder(
            merchantId: merchantId,
            merchantName: merchantName,
            merchantEmail: firstItem.product.merchantEmail,
            merchantLocation: firstItem.product.merchantLocation,
            merchantStoreName: firstItem.product.merchantStoreName,
            merchantImageUrl: firstItem.product.merchantImageUrl,
            merchantRating: firstItem.product.merchantRating,
            isMerchantVerified: firstItem.product.isMerchantVerified,
            isMerchantOpen: firstItem.product.isMerchantOpen,
            items: items,
            subtotal: subtotal,
          );
        })
        .where((order) => order != null)
        .cast<MerchantOrder>()
        .toList();

    // Create order with sub-orders for each merchant
    final order = app_order.Order(
      orderId: orderId,
      userId: userId,
      userEmail: userDetails.email,
      userName: '${userDetails.firstName} ${userDetails.lastName}',
      address: address,
      phoneNumber: phoneNumber,
      paymentMethod: paymentMethod,
      deliveryTime: deliveryTime,
      specialInstructions: specialInstructions,
      deliveryType: deliveryType,
      merchantOrders: merchantOrders,
      totalAmount: cart.totalPrice,
      date: now,
      status: 'pending',
    );

    // Save order to Firestore
    await orderRef.set(order.toJson());

    // Create merchant-specific order entries
    final batch = firestore.batch();

    for (final merchantOrder in merchantOrders) {
      final merchantOrderRef = firestore
          .collection('merchant_orders')
          .doc(merchantOrder.merchantId)
          .collection('orders')
          .doc(orderId);
           final merchantName = merchantOrder.merchantName.isNotEmpty
          ? merchantOrder.merchantName
          : "Unknown Merchant";

      batch.set(merchantOrderRef, {
        'orderId': orderId,
        'merchantId': merchantOrder.merchantId,
        'merchantName': merchantName,
        'items': merchantOrder.items
            .map((item) => {
                  'productName': item.product.productName,
                  'quantity': item.quantity,
                  'price': item.product.price,
                  'image': item.product.imageUrls.isNotEmpty
                      ? item.product.imageUrls.first
                      : "",
                  'productId': item.product.id,
                })
            .toList(),
        'subtotal': merchantOrder.subtotal,
        'userId': userId,
        'userEmail': userDetails.email,
        'userName': '${userDetails.firstName} ${userDetails.lastName}',
        'address': address,
        'phoneNumber': phoneNumber,
        'deliveryType': deliveryType,
        'paymentMethod': paymentMethod,
        'deliveryTime': deliveryTime,
        'specialInstructions': specialInstructions,
        'date': now.toIso8601String(),
        'status': 'pending',
      });
    }

    await batch.commit();

    // Send notification only after successful database operations
    await NotificationService.showOrderNotification(
      title: 'Order Placed Successfully!',
      body: 'Your order #$orderId has been placed.',
      userId: userId,
    );

    return order;
  }
}
