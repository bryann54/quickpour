import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/categories/presentation/widgets/shimmer_widget.dart';
import 'package:chupachap/features/home/presentation/widgets/voice_search_widget.dart';
import 'package:chupachap/features/merchant/presentation/pages/tab_view.dart';
import 'package:chupachap/features/product/presentation/widgets/product_section.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_event.dart';
import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_horizontal_list_widget.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_bloc.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_state.dart';
import 'package:chupachap/features/promotions/presentation/pages/promotions_screen.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promotions_carousel.dart';
import 'package:chupachap/features/product_search/presentation/pages/search_page.dart'; // Import the SearchPage
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  late ProductSearchBloc _productSearchBloc;
  final _searchController = TextEditingController();
  final _searchSubject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductsEvent());
    _scrollController = ScrollController();
    _productSearchBloc = ProductSearchBloc(
      productRepository: ProductRepository(),
    );

    // Setup debounce for search
    _searchSubject
        .debounceTime(const Duration(milliseconds: 300))
        .distinct()
        .listen((query) {
      _productSearchBloc.add(SearchProductsEvent(query));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchSubject.close();
    _productSearchBloc.close();
    super.dispose();
  }

  void _onVoiceResult(String recognizedText) {
    // Navigate to the SearchPage with the recognized query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          authRepository: AuthRepository(), // Pass your AuthRepository here
          searchController: TextEditingController(text: recognizedText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppBar(
        showNotification: true,
        showCart: false,
        showProfile: true,
        showGreeting: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, top: 2, bottom: 2, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Nearby  Stores',
                                style: GoogleFonts.montaga(
                                  textStyle: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: theme.colorScheme.onSurface,
                                          letterSpacing: 1),
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            // Icon(
                            //   size: 17,
                            //   Icons.verified,
                            //   color: isDarkMode
                            //       ? Colors.teal
                            //       : AppColors.accentColor,
                            // )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StoreTabsScreen(),
                              ),
                            );
                          },
                          child: Text('See All',
                              style: GoogleFonts.montaga(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? Colors.teal
                                          : AppColors.accentColor,
                                    ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<MerchantBloc, MerchantState>(
                    builder: (context, state) {
                      if (state is MerchantLoaded) {
                        return HorizontalMerchantsListWidget(
                            merchant: state.merchants);
                      }
                      if (state is MerchantLoading) {
                        return const Center(child: LoadingHorizontalList());
                      }
                      if (state is MerchantError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  BlocBuilder<PromotionsBloc, PromotionsState>(
                    builder: (context, state) {
                      if (state is PromotionsLoaded &&
                          state.promotions.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Promotions',
                                  style: GoogleFonts.montaga(
                                    fontSize: 20,
                                    textStyle:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PromotionsScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text('See All',
                                        style: GoogleFonts.montaga(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: isDarkMode
                                                    ? Colors.teal
                                                    : AppColors.accentColor,
                                              ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: PromotionsCarousel(),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ProductSection(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: VoiceSearchWidget(
        onVoiceResult: _onVoiceResult, // Pass the callback
      ),
    );
  }
}
