import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/features/promotions/data/models/promotion_model.dart';
import 'package:chupachap/features/promotions/presentation/pages/promo_details_screen.dart';
import 'package:flutter/material.dart';

class PromotionScreenCard extends StatelessWidget {
  final PromotionModel promotion;

  const PromotionScreenCard({super.key, required this.promotion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PromoDetailsScreen(promotion: promotion),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: promotion.imageUrl ?? '',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => _placeholder(),
                errorWidget: (context, url, error) => _placeholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promotion.campaignTitle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${promotion.promotionType} • ${promotion.discountPercentage.toStringAsFixed(0)}% OFF',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        height: 160,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Icon(Icons.error_outline_outlined,
            size: 40, color: Colors.grey),
      );
}
