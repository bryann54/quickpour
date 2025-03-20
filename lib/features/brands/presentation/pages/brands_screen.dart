import 'package:chupachap/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:chupachap/features/brands/presentation/widgets/brands_card_widget.dart';
import 'package:chupachap/features/brands/presentation/widgets/brands_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final brandsBloc = context.read<BrandsBloc>();
      if (brandsBloc.state is BrandsLoadedState &&
          (brandsBloc.state as BrandsLoadedState).hasMoreData) {
        brandsBloc.add(LoadMoreBrandsEvent());
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 50); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BrandsBloc, BrandsState>(
          builder: (context, state) {
            if (state is BrandsLoadingState) {
              return const Center(child: BrandsScreenShimmer());
            } else if (state is BrandsLoadedState ||
                state is BrandsLoadingMoreState) {
              final brands = state is BrandsLoadedState
                  ? state.brands
                  : (state as BrandsLoadingMoreState).brands;
              final hasMoreData = state is BrandsLoadedState
                  ? state.hasMoreData
                  : true; 

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: MasonryGridView.count(
                        controller: _scrollController,
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemCount: brands.length + (hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == brands.length && hasMoreData) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator.adaptive(),
                                  ],
                                ),
                              ),
                            );
                          }
                          final brand = brands[index];
                          return BrandCardWidget(
                            brand: brand,
                            isVerified: index % 3 == 0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No brands available'));
          },
        ),
      ),
    );
  }
}
