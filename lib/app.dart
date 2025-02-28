import 'package:chupachap/core/theme/app_theme.dart';
import 'package:chupachap/core/theme/theme_controller.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'package:chupachap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chupachap/features/auth/presentation/pages/entry_splash.dart';
import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';
import 'package:chupachap/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:chupachap/features/cart/data/repositories/cart_repository.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/categories/domain/usecases/fetch_categories.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_event.dart';
import 'package:chupachap/features/checkout/domain/repositories/checkout_repository_impl.dart';
import 'package:chupachap/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/drink_request/data/repositories/drink_request_repository.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_bloc.dart';
import 'package:chupachap/features/favorites/data/repositories/favorites_repository.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/notifications/data/repositories/notifications_repository.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/orders/data/repositories/orders_repository.dart';
import 'package:chupachap/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/promotions/data/repositories/promotions_repository.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_bloc.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_event.dart';
import 'package:chupachap/features/user_data/data/repositories/user_data_repository_impl.dart';
import 'package:chupachap/features/user_data/presentation/bloc/user_data_bloc.dart';
import 'package:chupachap/features/wallet/data/repositories/wallet_repository.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final merchantRepository = MerchantsRepository();
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>(
          create: (_) => firestore,
        ),
        Provider<FirebaseAuth>(
          create: (_) => auth,
        ),
        Provider<NotificationsRepository>(
          create: (context) => NotificationsRepository(
            firestore: context.read<FirebaseFirestore>(),
            auth: context.read<FirebaseAuth>(),
          ),
        ),
        Provider<DrinkRequestRepository>(
          create: (context) => DrinkRequestRepository(AuthRepository()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authUseCases: AuthUseCases(
                authRepository: AuthRepository(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => UserDataBloc(
              repository:
                  UserDataRepositoryImpl(authRepository: AuthRepository()),
            )..add(FetchUserData()),
          ),
          BlocProvider(
            create: (context) => DrinkRequestBloc(
              context.read<DrinkRequestRepository>(),
            ),
          ),
          // Move NotificationsBloc after auth bloc
          BlocProvider(
            create: (context) => NotificationsBloc(
              repository: NotificationsRepository(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                PromotionsBloc(promotionsRepository: PromotionsRepository())
                  ..add(FetchActivePromotions()),
          ),

          BlocProvider(
            create: (_) =>
                MerchantBloc(merchantRepository)..add(FetchMerchantEvent()),
          ),
          BlocProvider(
            create: (context) => CartBloc(
              cartRepository: CartRepository(firestore: firestore),
              userId: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
          BlocProvider(
            create: (context) {
              final checkoutRepository = CheckoutRepositoryImpl(
                firestore: context.read<FirebaseFirestore>(),
                authUseCases: context.read<AuthBloc>().authUseCases,
              );
              final placeOrderUseCase = PlaceOrderUseCase(checkoutRepository);

              return CheckoutBloc(
                placeOrderUseCase: placeOrderUseCase,
              );
            },
          ),
          BlocProvider(
            create: (context) => OrdersBloc(
              checkoutBloc: context.read<CheckoutBloc>(),
              ordersRepository: OrdersRepository(
                context.read<FirebaseFirestore>(),
              ),
            ),
          ),
          BlocProvider(
            create: (_) => BrandsBloc(brandRepository: BrandRepository())
              ..add(FetchBrandsEvent()),
          ),
          BlocProvider(
            create: (context) => CategoriesBloc(
              FetchCategories(CategoryRepository()),
            )..add(LoadCategories()),
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(
                favoritesRepository: FavoritesRepository(
              firestore: FirebaseFirestore.instance,
              authRepository: AuthRepository(),
            ))
              ..add(LoadFavoritesEvent()),
          ),
          BlocProvider(
            create: (context) => WalletBloc(
              walletRepository: WalletRepository(),
            ),
          ),
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
