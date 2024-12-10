import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductPriceSection extends StatelessWidget {
  final ProductModel product;

  const ProductPriceSection({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'KSh ${(product.price).toStringAsFixed(2)}',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppColors.primaryColor),
        ),
      ],
    );
  }
}
