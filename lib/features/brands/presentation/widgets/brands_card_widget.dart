import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/brands/presentation/pages/brand_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BrandCardWidget extends StatelessWidget {
  final BrandModel brand;
  final bool isVerified;

  const BrandCardWidget({
    super.key,
    required this.brand,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _navigateToBrandDetails(context),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Image with Hero
            Hero(
              tag: 'brand-image-${brand.logoUrl}',
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: brand.logoUrl,
                  placeholder: (context, url) => Container(
                    height: 120,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator.adaptive()),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 48),
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Brand Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'brand-name-${brand.name}',
                    child: Material(
                      child: Text(
                        brand.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    brand.country,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
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

  void _navigateToBrandDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BrandDetailsScreen(brand: brand),
      ),
    );
  }
}
