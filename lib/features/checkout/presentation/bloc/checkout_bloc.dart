import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/checkout/domain/entities/merchant_order.dart';
import 'package:chupachap/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PlaceOrderUseCase placeOrderUseCase;

  CheckoutBloc({
    required this.placeOrderUseCase,
  }) : super(const CheckoutInitialState()) {
    on<UpdateDeliveryInfoEvent>(_onUpdateDeliveryInfo);
    on<UpdatePaymentMethodEvent>(_onUpdatePaymentMethod);
    on<UpdateDeliveryTimeEvent>(_onUpdateDeliveryTime);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  void _onUpdateDeliveryInfo(
      UpdateDeliveryInfoEvent event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(
      address: event.address,
      phoneNumber: event.phoneNumber,
      deliveryType: event.deliveryType,
    ));
  }

  void _onUpdatePaymentMethod(
      UpdatePaymentMethodEvent event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(paymentMethod: event.paymentMethod));
  }

  void _onUpdateDeliveryTime(
      UpdateDeliveryTimeEvent event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(
      deliveryTime: event.deliveryTime,
      specialInstructions: event.specialInstructions,
    ));
  }

  Future<void> _onPlaceOrder(
      PlaceOrderEvent event, Emitter<CheckoutState> emit) async {
    try {
      // Check if cart has items before proceeding
      if (event.cart.items.isEmpty) {
        emit(CheckoutErrorState(
          errorMessage: 'Failed to place order: Cart is empty',
          address: state.address,
          phoneNumber: state.phoneNumber,
          paymentMethod: state.paymentMethod,
          deliveryTime: state.deliveryTime,
          specialInstructions: state.specialInstructions,
          deliveryType: state.deliveryType,
          userEmail: state.userEmail,
          userName: state.userName,
          userId: state.userId,
        ));
        return;
      }

      emit(CheckoutLoadingState(
        address: state.address,
        phoneNumber: state.phoneNumber,
        paymentMethod: state.paymentMethod,
        deliveryTime: state.deliveryTime,
        specialInstructions: state.specialInstructions,
        deliveryType: state.deliveryType,
        userEmail: state.userEmail,
        userName: state.userName,
        userId: state.userId,
      ));

      // Place the order
      final order = await placeOrderUseCase.execute(
        cart: event.cart,
        deliveryTime: event.deliveryTime,
        specialInstructions: event.specialInstructions,
        paymentMethod: event.paymentMethod,
        address: event.address,
        phoneNumber: event.phoneNumber,
        deliveryType: event.deliveryType,
      );

      // Group cart items by merchant
      final merchantItemsMap = <String, List<CartItem>>{};
      for (final item in event.cart.items) {
        final merchantId = item.product.merchantId;
        if (merchantId.isEmpty) {
          throw Exception('Invalid merchantId for product: ${item.product.id}');
        }
        merchantItemsMap.putIfAbsent(merchantId, () => []).add(item);
      }

      // Create merchant orders
      final merchantOrders = <MerchantOrder>[];
      for (final entry in merchantItemsMap.entries) {
        final merchantId = entry.key;
        final items = entry.value;

        // Skip if there are no items for this merchant
        if (items.isEmpty) {
          continue;
        }

        final firstItem = items.first;

        // Calculate subtotal for this merchant
        final subtotal = items.fold<double>(
            0, (sum, item) => sum + (item.quantity * item.product.price));

        merchantOrders.add(MerchantOrder(
          merchantId: merchantId,
          merchantName: firstItem.product.merchantName,
          merchantEmail: firstItem.product.merchantEmail,
          merchantLocation: firstItem.product.merchantLocation,
          merchantStoreName: firstItem.product.merchantStoreName,
          merchantImageUrl: firstItem.product.merchantImageUrl,
          merchantRating: firstItem.product.merchantRating,
          isMerchantVerified: firstItem.product.isMerchantVerified,
          isMerchantOpen: firstItem.product.isMerchantOpen,
          items: items,
          subtotal: subtotal,
        ));
      }

      // Emit success state
      emit(CheckoutOrderPlacedState(
        orderId: order.orderId,
        totalAmount: order.totalAmount,
        merchantOrders: merchantOrders,
        status: order.status,
        address: order.address,
        phoneNumber: order.phoneNumber,
        paymentMethod: order.paymentMethod,
        deliveryTime: order.deliveryTime,
        specialInstructions: order.specialInstructions,
        deliveryType: order.deliveryType,
        userEmail: order.userEmail,
        userName: order.userName,
        userId: order.userId,
      ));

      // Clear the cart after successful order placement
      // Assuming you have a CartBloc or similar to manage the cart state
      // cartBloc.add(ClearCartEvent());
    } catch (e) {
      emit(CheckoutErrorState(
        errorMessage: 'Failed to place order: ${e.toString()}',
        address: state.address,
        phoneNumber: state.phoneNumber,
        paymentMethod: state.paymentMethod,
        deliveryTime: state.deliveryTime,
        specialInstructions: state.specialInstructions,
        deliveryType: state.deliveryType,
        userEmail: state.userEmail,
        userName: state.userName,
        userId: state.userId,
      ));
    }
  }
}
