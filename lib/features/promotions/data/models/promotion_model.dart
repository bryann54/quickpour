class PromotionModel {
  final String id;
  final String merchantId; // Added merchantId as required field
  final List<String> productIds;
  final List<String> categoryIds;
  final List<String> brandIds;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String description;
  final String promotionType;
  final String? imageUrl;
  final String campaignTitle;
  final PromotionTarget promotionTarget;
  final PromotionStatus status; // Added status enum for better tracking
  final int? usageLimit; // Optional field to limit redemptions
  final int usageCount; // Track how many times promotion was used
  final bool isFeatured; // Allow merchants to highlight special promotions

  PromotionModel({
    required this.id,
    required this.merchantId, // Required parameter
    this.productIds = const [],
    this.categoryIds = const [],
    this.brandIds = const [],
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.description,
    required this.promotionType,
    required this.campaignTitle,
    required this.promotionTarget,
    this.imageUrl,
    this.status = PromotionStatus.active, // Default to active
    this.usageLimit,
    this.usageCount = 0,
    this.isFeatured = false,
  });

  PromotionModel copyWith({
    String? id,
    String? merchantId,
    List<String>? productIds,
    List<String>? categoryIds,
    List<String>? brandIds,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? description,
    String? promotionType,
    String? imageUrl,
    String? campaignTitle,
    PromotionTarget? promotionTarget,
    PromotionStatus? status,
    int? usageLimit,
    int? usageCount,
    bool? isFeatured,
  }) {
    return PromotionModel(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      productIds: productIds ?? this.productIds,
      categoryIds: categoryIds ?? this.categoryIds,
      brandIds: brandIds ?? this.brandIds,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      promotionType: promotionType ?? this.promotionType,
      imageUrl: imageUrl ?? this.imageUrl,
      campaignTitle: campaignTitle ?? this.campaignTitle,
      promotionTarget: promotionTarget ?? this.promotionTarget,
      status: status ?? this.status,
      usageLimit: usageLimit ?? this.usageLimit,
      usageCount: usageCount ?? this.usageCount,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      merchantId: json['merchantId'], // Parse merchantId
      productIds: List<String>.from(json['productIds'] ?? []),
      categoryIds: List<String>.from(json['categoryIds'] ?? []),
      brandIds: List<String>.from(json['brandIds'] ?? []),
      discountPercentage: json['discountPercentage'].toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
      description: json['description'],
      promotionType: json['promotionType'],
      imageUrl: json['imageUrl'],
      campaignTitle: json['campaignTitle'],
      promotionTarget: PromotionTarget.values.firstWhere(
        (e) => e.toString() == json['promotionTarget'],
        orElse: () => PromotionTarget.products,
      ),
      status: json['status'] != null
          ? PromotionStatus.values.firstWhere(
              (e) => e.toString() == json['status'],
              orElse: () => PromotionStatus.active,
            )
          : PromotionStatus.active,
      usageLimit: json['usageLimit'],
      usageCount: json['usageCount'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantId': merchantId,
      'productIds': productIds,
      'categoryIds': categoryIds,
      'brandIds': brandIds,
      'discountPercentage': discountPercentage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'description': description,
      'promotionType': promotionType,
      'campaignTitle': campaignTitle,
      'imageUrl': imageUrl,
      'promotionTarget': promotionTarget.toString(),
      'status': status.toString(),
      'usageLimit': usageLimit,
      'usageCount': usageCount,
      'isFeatured': isFeatured,
    };
  }

  // Helper method to check if promotion is valid
  bool isValidNow() {
    final now = DateTime.now();
    return isActive &&
        status == PromotionStatus.active &&
        now.isAfter(startDate) &&
        now.isBefore(endDate) &&
        (usageLimit == null || usageCount < usageLimit!);
  }

  // Helper method to check if promotion applies to a product
  bool appliesToProduct(String productId, String? categoryId, String? brandId) {
    switch (promotionTarget) {
      case PromotionTarget.products:
        return productIds.contains(productId);
      case PromotionTarget.categories:
        return categoryId != null && categoryIds.contains(categoryId);
      case PromotionTarget.brands:
        return brandId != null && brandIds.contains(brandId);
      default:
        return false;
    }
  }

  // Helper method to increment usage count
  PromotionModel incrementUsage() {
    return copyWith(usageCount: usageCount + 1);
  }
}

enum PromotionTarget {
  products,
  categories,
  brands,
}

// New enum for promotion status
enum PromotionStatus { draft, active, paused, expired, deleted }
