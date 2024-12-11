
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/presentation/widgets/cart_footer.dart';
import 'package:chupachap/features/product/presentation/widgets/merchants_details_section.dart';
import 'package:chupachap/features/product/presentation/widgets/product_category_section.dart';
import 'package:chupachap/features/product/presentation/widgets/product_details_header.dart';
import 'package:chupachap/features/product/presentation/widgets/product_image_gallery.dart';
import 'package:chupachap/features/product/presentation/widgets/product_price_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.initialQuantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity;
    });
    widget.onQuantityChanged(quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showNotification: true,
        showProfile: false,
        
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<CartBloc>()),
          BlocProvider.value(value: context.read<FavoritesBloc>()),
        ],
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageGallery(product: widget.product),
                    const SizedBox(height: 16),
                    ProductDetailsHeader(product: widget.product),
                    const SizedBox(height: 16),
                    ProductCategorySection(product: widget.product),
                    const SizedBox(height: 6),
                    MerchantsDetailsSection(product: widget.product),
                    const SizedBox(height: 16),
                    ProductPriceSection(product: widget.product),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            CartFooter(
              product: widget.product,
              currentQuantity: quantity,
              onQuantityChanged: _updateQuantity,
            ),
          ],
        ),
      ),
    );
  }
}
