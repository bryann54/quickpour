class Order {
  final String id;
  final DateTime date;
  final double total;
  final String address;
  final String phoneNumber;
  final String paymentMethod;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.address,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
