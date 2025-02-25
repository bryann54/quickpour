class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final List<String> images;
  final String measure;
  final String sku;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.images,
    required this.measure,
    required this.sku,
  });

  factory OrderItem.fromFirebase(Map<String, dynamic> data) {
    // Handle the image field which can be either a List<dynamic> or a String
    List<String> parseImages(dynamic imageData) {
      if (imageData is List) {
        return imageData.map((e) => e.toString()).toList();
      } else if (imageData is String) {
        return [imageData];
      }
      return [];
    }

    return OrderItem(
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      images: parseImages(data['image']),
      measure: data['measure'] ?? '',
      sku: data['sku'] ?? '',
    );
  }
}
