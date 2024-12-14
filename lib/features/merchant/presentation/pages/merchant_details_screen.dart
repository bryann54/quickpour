import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_details_header.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MerchantDetailsScreen extends StatelessWidget {
  final Merchants merchant;

  const MerchantDetailsScreen({Key? key, required this.merchant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => ProductBloc(
        productRepository: ProductRepository(),
      )..add(FetchProductsEvent()),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // SliverAppBar with MerchantDetailsHeader
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: MerchantDetailsHeader(merchant: merchant),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            // Remaining Content
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator.adaptive()),
                    ),
                  );
                }

                if (state is ProductLoadedState) {
                  // Filter products for the current merchant
                  final merchantProducts = state.products
                      .where((product) => product.merchants.id == merchant.id)
                      .toList();

                  return SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = merchantProducts[index];
                          return ProductCard(product: product);
                        },
                        childCount: merchantProducts.length,
                      ),
                    ),
                  );
                }

                if (state is ProductErrorState) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        state.errorMessage,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.red),
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }

}
