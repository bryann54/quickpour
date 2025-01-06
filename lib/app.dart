import 'package:chupachap/core/theme/app_theme.dart';
import 'package:chupachap/core/theme/theme_controller.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chupachap/features/auth/presentation/pages/entry_splash.dart';
import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';
import 'package:chupachap/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/categories/domain/usecases/fetch_categories.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_event.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/notifications/data/repositories/notifications_repository.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/orders/data/repositories/orders_repository.dart';
import 'package:chupachap/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final merchantRepository = MerchantsRepository();

    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>(
          create: (_) => FirebaseFirestore.instance,
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authUseCases: AuthUseCases(
              authRepository: AuthRepository(),
            ),
          ),
        ),
        Provider<NotificationsRepository>(
          create: (_) => NotificationsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotificationsBloc(
              context.read<NotificationsRepository>(),
            ),
          ),
          BlocProvider<ProductSearchBloc>(
            create: (context) => ProductSearchBloc(
              productRepository: ProductRepository(),
            ),
          ),
          BlocProvider(
            create: (_) =>
                MerchantBloc(merchantRepository)..add(FetchMerchantEvent()),
          ),
          BlocProvider(create: (_) => CartBloc()),
     BlocProvider(
            create: (context) {
              final checkoutBloc = CheckoutBloc(
                firestore: context.read<FirebaseFirestore>(),
                authUseCases:
                    context.read<AuthBloc>().authUseCases, // Add AuthUseCases
              );

              // Listen to CheckoutBloc to clear cart when order is placed
              checkoutBloc.stream.listen((state) {
                if (state is CheckoutOrderPlacedState) {
                  context.read<CartBloc>().add(ClearCartEvent());
                } else if (state is CheckoutErrorState) {
                  // Optionally handle error states
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              });

              return checkoutBloc;
            },
          ),
        BlocProvider(
            create: (context) => OrdersBloc(
              checkoutBloc: context.read<CheckoutBloc>(),
              ordersRepository:
                  OrdersRepository(context.read<FirebaseFirestore>()),
            ),
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
      ),
    );
  }
}
