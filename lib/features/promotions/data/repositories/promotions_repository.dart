import 'package:chupachap/features/promotions/data/models/promotion_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionsRepository {
  final FirebaseFirestore _firestore;

  PromotionsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _promotionsCollection =>
      _firestore.collection('promotions');

  // For consumer app: Fetch all active promotions
  Future<List<PromotionModel>> fetchActivePromotions() async {
    try {
      final now = DateTime.now();

      // Debug prints
      print('Fetching active promotions at ${now.toIso8601String()}');

      // Simplified query with fewer conditions
      final querySnapshot = await _promotionsCollection
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: PromotionStatus.active.toString())
          .get();

      print('Found ${querySnapshot.docs.length} promotions in initial query');

      // Manual filtering for dates to debug date issues
      final filteredDocs = querySnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final startDate = DateTime.parse(data['startDate'] as String);
        final endDate = DateTime.parse(data['endDate'] as String);
        final isInDateRange = startDate.isBefore(now) && endDate.isAfter(now);

        print(
            'Promotion ${doc.id}: startDate=${data['startDate']}, endDate=${data['endDate']}, isInDateRange=$isInDateRange');

        return isInDateRange;
      }).toList();

      print('After date filtering: ${filteredDocs.length} promotions remain');

      return filteredDocs
          .map((doc) => PromotionModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      print('Error fetching active promotions: ${e.toString()}');
      throw Exception('Failed to fetch active promotions: $e');
    }
  }

  // For consumer app: Fetch featured promotions
  Future<List<PromotionModel>> fetchFeaturedPromotions() async {
    try {
      final now = DateTime.now();
      final querySnapshot = await _promotionsCollection
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: PromotionStatus.active.toString())
          .where('isFeatured', isEqualTo: true)
          .where('startDate', isLessThanOrEqualTo: now.toIso8601String())
          .where('endDate', isGreaterThanOrEqualTo: now.toIso8601String())
          .get();

      return querySnapshot.docs
          .map((doc) => PromotionModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      print('Error fetching featured promotions: ${e.toString()}');
      throw Exception('Failed to fetch featured promotions: $e');
    }
  }

  // For consumer app: Fetch all active promotions for a specific merchant
  Future<List<PromotionModel>> fetchActiveMerchantPromotions(
      String merchantId) async {
    try {
      final now = DateTime.now();
      final querySnapshot = await _promotionsCollection
          .where('merchantId', isEqualTo: merchantId)
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: PromotionStatus.active.toString())
          .where('startDate', isLessThanOrEqualTo: now.toIso8601String())
          .where('endDate', isGreaterThanOrEqualTo: now.toIso8601String())
          .get();

      return querySnapshot.docs
          .map((doc) => PromotionModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      print('Error fetching merchant promotions: ${e.toString()}');
      throw Exception('Failed to fetch merchant promotions: $e');
    }
  }

  // Improved implementation for fetching promotions by products
  // that checks all three promotion targets: products, categories, and brands
  Future<List<PromotionModel>> fetchPromotionsForProducts(
      List<String> productIds,
      List<String> categoryIds,
      List<String> brandIds) async {
    try {
      final now = DateTime.now();

      // Get all active promotions first
      final querySnapshot = await _promotionsCollection
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: PromotionStatus.active.toString())
          .where('startDate', isLessThanOrEqualTo: now.toIso8601String())
          .where('endDate', isGreaterThanOrEqualTo: now.toIso8601String())
          .get();

      // Manual filtering for each promotion target type
      List<PromotionModel> applicablePromotions = [];

      for (var doc in querySnapshot.docs) {
        final promotion = PromotionModel.fromJson({
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        });

        bool isApplicable = false;

        switch (promotion.promotionTarget) {
          case PromotionTarget.products:
            // Check if any product ID matches
            isApplicable =
                promotion.productIds.any((id) => productIds.contains(id));
            break;
          case PromotionTarget.categories:
            // Check if any category ID matches
            isApplicable =
                promotion.categoryIds.any((id) => categoryIds.contains(id));
            break;
          case PromotionTarget.brands:
            // Check if any brand ID matches
            isApplicable =
                promotion.brandIds.any((id) => brandIds.contains(id));
            break;
        }

        if (isApplicable) {
          applicablePromotions.add(promotion);
        }
      }

      return applicablePromotions;
    } catch (e) {
      print('Error fetching promotions for products: ${e.toString()}');
      throw Exception('Failed to fetch promotions for products: $e');
    }
  }
}
