import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MerchantsScreen extends StatelessWidget {
  const MerchantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Partner Stores',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => MerchantBloc(MerchantsRepository())
                ..add(FetchMerchantEvent()),
              child: BlocBuilder<MerchantBloc, MerchantState>(
                builder: (context, state) {
                  if (state is MerchantLoading) {
                    return _buildShimmerLoading();
                  } else if (state is MerchantLoaded) {
                    final merchants = state.merchants;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: merchants.length,
                      itemBuilder: (context, index) {
                        final merchant = merchants[index];
                        return MerchantCardWidget(merchant: merchant);
                      },
                    );
                  } else if (state is MerchantError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5, // Show 5 shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Shimmer for Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shimmer for Name
                        Container(
                          width: double.infinity,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        // Shimmer for Location
                        Container(
                          width: 150,
                          height: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  // Shimmer for Rating
                  Container(
                    width: 60,
                    height: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
