class Merchants {
  final String id;
  final String name;
  final String location;
  final List<String> products;
  final int experience;
  final String imageUrl;
  final double rating;
  final bool isVerified;
  final bool isOpen;

  Merchants({
    required this.id,
    required this.name,
    required this.location,
    required this.products,
    required this.experience,
    required this.imageUrl,
    required this.rating,
    required this.isOpen,
    required this.isVerified,
  });

  factory Merchants.fromJson(Map<String, dynamic> json) {
    return Merchants(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        products: List<String>.from(json['products']),
        experience: json['experience'],
        imageUrl: json['imageUrl'],
        rating: (json['rating'] as num).toDouble(),
        isVerified: json['isVerified'],
        isOpen: json['isOpen']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'products': products,
      'experience': experience,
      'imageUrl': imageUrl,
      'rating': rating,
      'isVerified': isVerified,
    };
  }
}
