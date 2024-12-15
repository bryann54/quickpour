import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_card_widget.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_tile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MerchantsScreen extends StatelessWidget {
  const MerchantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    return MerchantTileShimmer();
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
}
