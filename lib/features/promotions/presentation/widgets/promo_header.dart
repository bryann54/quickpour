import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromoHeader extends StatelessWidget {
  final String? imageUrl;
  final String promotionId;

  const PromoHeader({
    super.key,
    required this.imageUrl,
    required this.promotionId,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl != null && imageUrl!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
            placeholder: (context, url) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.error, size: 50),
            ),
          )
        : Container(
            height: 200,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: const Center(child: Icon(Icons.local_offer, size: 50)),
          );
  }
}
