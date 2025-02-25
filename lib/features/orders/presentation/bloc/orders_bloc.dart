import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:chupachap/features/notifications/domain/repositories/notification_service.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/data/models/merchant_order_item_model.dart';
import 'package:chupachap/features/orders/data/models/order_model.dart';
import 'package:chupachap/features/orders/data/repositories/orders_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CheckoutBloc checkoutBloc;
  final OrdersRepository ordersRepository;

  OrdersBloc({
    required this.checkoutBloc,
    required this.ordersRepository,
  }) : super(OrdersInitial()) {
    on<LoadOrdersFromCheckout>(_onLoadOrders);
    on<AddNewOrder>(_onAddNewOrder);

    // Listen to checkout completion
    checkoutBloc.stream.listen((state) {
      if (state is CheckoutOrderPlacedState) {
        // Convert merchant orders to our internal structure
        final merchantOrderItems = state.merchantOrders.map((merchantOrder) {
          // Convert cart items to order items
          final orderItems = merchantOrder.items
              .map((item) => OrderItem(
                    productName: item.product.productName,
                    measure: item.product.measure,
                    quantity: item.quantity,
                    price: item.product.price,
                    sku: item.product.sku,
                    images: item.product.imageUrls.isNotEmpty
                        ? [item.product.imageUrls.first]
                        : [],
                    productId: item.product.id,
                  ))
              .toList();

          return MerchantOrderItem(
            merchantEmail: merchantOrder.merchantEmail,
            merchantLocation: merchantOrder.merchantLocation,
            merchantStoreName: merchantOrder.merchantStoreName,
            merchantRating: merchantOrder.merchantRating,
            isMerchantOpen: merchantOrder.isMerchantOpen,
            isMerchantVerified: merchantOrder.isMerchantOpen,
            merchantId: merchantOrder.merchantId,
            merchantName: merchantOrder.merchantName,
            merchantImageUrl: merchantOrder.merchantImageUrl,
            items: orderItems,
            subtotal: merchantOrder.subtotal,
          );
        }).toList();

        final newOrder = CompletedOrder(
          id: state.orderId,
          total: state.totalAmount,
          date: DateTime.now(),
          address: state.address ?? 'No address provided',
          phoneNumber: state.phoneNumber ?? 'No phone number',
          paymentMethod: state.paymentMethod ?? 'Not specified',
          merchantOrders: merchantOrderItems,
          userEmail: state.userEmail ?? 'No email provided',
          userName: state.userName ?? 'No name provided',
          userId: state.userId ?? 'No user ID provided',
          status: state.status,
        );

        // Show notification with userId
        NotificationService.showOrderNotification(
          title: 'Order Placed Successfully',
          body: 'Your order #${state.orderId} has been confirmed',
          userId: state.userId ?? 'No user ID provided',
          payload: state.orderId,
        );

        add(AddNewOrder(newOrder));
      }
    });
  }

  Future<void> _onLoadOrders(
    LoadOrdersFromCheckout event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final orders = await ordersRepository.getOrders();
      if (orders.isEmpty) {
        emit(OrdersEmpty());
      } else {
        emit(OrdersLoaded(orders));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  void _onAddNewOrder(AddNewOrder event, Emitter<OrdersState> emit) {
    if (state is OrdersLoaded) {
      final currentOrders = (state as OrdersLoaded).orders;
      emit(OrdersLoaded([...currentOrders, event.order]));
    } else {
      emit(OrdersLoaded([event.order]));
    }
  }
}
