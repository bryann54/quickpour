import 'package:chupachap/core/theme/app_theme.dart';
import 'package:chupachap/core/theme/theme_controller.dart';
import 'package:chupachap/features/auth/presentation/pages/entry_splash.dart';
import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';
import 'package:chupachap/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/categories/domain/usecases/fetch_categories.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_event.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final merchantRepository = MerchantsRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductSearchBloc>(
          create: (context) => ProductSearchBloc(
            productRepository: ProductRepository(),
          ),
        ),
        BlocProvider(
          create: (_) =>
              MerchantBloc(merchantRepository)..add(FetchMerchantEvent()),
        ),
        BlocProvider(
          create: (context) =>
              OrdersBloc(checkoutBloc: context.read<CheckoutBloc>())
                ..add(LoadOrdersFromCheckout()),
        ),
        BlocProvider(
          create: (_) => BrandsBloc(brandRepository: BrandRepository())
            ..add(FetchBrandsEvent()),
        ),
        BlocProvider(
          create: (context) => CategoriesBloc(FetchCategories(
            CategoryRepository(),
          ))
            ..add(LoadCategories()),
        ),
        BlocProvider(create: (_) => FavoritesBloc()),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(
          create: (context) => ProductBloc(
            productRepository: ProductRepository(),
          ),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeController(),
        child: Consumer<ThemeController>(
          builder: (context, themeController, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.themeMode,
              home: const EntrySplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
