import 'package:chupachap/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:chupachap/features/brands/presentation/widgets/brands_card_widget.dart';
import 'package:chupachap/features/brands/presentation/widgets/brands_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BrandsBloc, BrandsState>(
          builder: (context, state) {
            if (state is BrandsLoadingState) {
              return const Center(child: BrandsScreenShimmer());
            } else if (state is BrandsLoadedState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MasonryGridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: state.brands.length,
                  itemBuilder: (context, index) {
                    final brand = state.brands[index];
                    return BrandCardWidget(
                      brand: brand,
                      isVerified: index % 3 == 0,
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('Failed to load brands '));
          },
        ),
      ),
    );
  }
}
