import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_card_widget.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_tile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MerchantsScreen extends StatefulWidget {
  const MerchantsScreen({super.key});

  @override
  State<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<MerchantBloc>().add(FetchMerchantEvent());
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<MerchantBloc>().add(FetchMoreMerchantsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<MerchantBloc, MerchantState>(
              builder: (context, state) {
                if (state is MerchantLoading) {
                  return const MerchantTileShimmer();
                } else if (state is MerchantLoaded) {
                  final merchants = state.merchants;
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: merchants.length + 1,
                    itemBuilder: (context, index) {
                      if (index < merchants.length) {
                        final merchant = merchants[index];
                        return MerchantCardWidget(merchant: merchant);
                      } else if (state.hasMoreData) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator.adaptive()),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
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
        ],
      ),
    );
  }
}
