import 'package:chupachap/features/product/presentation/widgets/cart_quantityFAB.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/core/utils/functions.dart';

class PromoProductCard extends StatelessWidget {
  final ProductModel product;

  const PromoProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final discountedPrice =
        product.price * (1 - 0.2); // Replace with actual discount logic
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children:[ Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl:
                      product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child:
                        Icon(Icons.error, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.productName,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.measure
                        ),
                        Text(
                          'Ksh ${formatMoney(discountedPrice)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Ksh ${formatMoney(product.price)}',
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Positioned(
        //   bottom: 8,
        //   right: 8,
        //   child: PromoQuantityFAB(
        //     product: product,
        //     isDarkMode: isDarkMode,
        //   ),
        // ),
            Positioned(
                  bottom: 8,
                  right: 8,
                  child: CartQuantityFAB(
                    product: product,
                    isDarkMode: isDarkMode,
                  ),
                ),]
      ),
    );
  }
}
