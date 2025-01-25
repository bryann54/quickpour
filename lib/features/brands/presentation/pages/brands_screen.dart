import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';
import 'package:chupachap/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:chupachap/features/brands/presentation/widgets/brands_card_widget.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_tile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: BlocProvider(
              create: (context) =>
                  BrandsBloc(brandRepository: BrandRepository())
                    ..add(FetchBrandsEvent()),
              child: BlocBuilder<BrandsBloc, BrandsState>(
                builder: (context, state) {
                  if (state is BrandsLoadingState) {
                    return const Center(child: MerchantTileShimmer());
                  } else if (state is BrandsLoadedState) {
                    return ListView.builder(
                      itemCount: state.brands.length,
                      itemBuilder: (context, index) {
                        final brand = state.brands[index];
                        return BrandCardWidget(
                          brand: brand,
                        );
                      },
                    );
                  }
                  return const Text('Failed to load brands');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
