class BrandModel {
  final String id;
  final String name;
  final String country;
  final String description;
  final String logoUrl;

  BrandModel({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.logoUrl,
  });

  // JSON serialization methods
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      description: json['description'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'logoUrl': logoUrl,
    };
  }

  // Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
