class Farmer {
  final String id;
  final String name;
  final String location;
  final List<String> crops;
  final int experience;
  final String imageUrl;
  final double rating;
  final bool isVerified;

  Farmer({
    required this.id,
    required this.name,
    required this.location,
    required this.crops,
    required this.experience,
    required this.imageUrl,
    required this.rating,
    required this.isVerified,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      crops: List<String>.from(json['crops']),
      experience: json['experience'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num).toDouble(),
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'crops': crops,
      'experience': experience,
      'imageUrl': imageUrl,
      'rating': rating,
      'isVerified': isVerified,
    };
  }
}
