import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
}

class Cart extends Equatable {
  final List<CartItem> items;

  const Cart({this.items = const []});

double get totalPrice => items.fold(0, (total, item) {
        final itemPrice = item.product.discountPrice > 0 &&
                item.product.discountPrice < item.product.price
            ? item.product.discountPrice
            : item.product.price;
        return total + (itemPrice * item.quantity);
      });

  int get totalQuantity =>
      items.fold(0, (total, item) => total + item.quantity);

  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}
