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
import 'package:chupachap/features/drink_request/data/repositories/drink_request_repository.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';
import 'package:chupachap/features/notifications/data/repositories/notifications_repository.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/orders/data/repositories/orders_repository.dart';
import 'package:chupachap/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
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
          create: (context) => DrinkRequestRepository(
            firestore: context.read<FirebaseFirestore>(),
          ),
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
            create: (context) => DrinkRequestBloc(
              context.read<DrinkRequestRepository>(),
            ),
          ),
          // Move NotificationsBloc after auth bloc
          BlocProvider<NotificationsBloc>(
            lazy: false,
            create: (context) {
              final bloc = NotificationsBloc(
                context.read<NotificationsRepository>(),
              );
              if (FirebaseAuth.instance.currentUser != null) {
                bloc.add(FetchNotifications());
                bloc.add(FetchUnreadCount());
              }
              return bloc;
            },
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
                authUseCases: context.read<AuthBloc>().authUseCases,
              );

              // Listen for checkout events to create notifications
              checkoutBloc.stream.listen((state) {
                if (state is CheckoutOrderPlacedState) {
                  final notificationsRepo =
                      context.read<NotificationsRepository>();
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId != null) {
                    notificationsRepo.createNotification(
                      title: 'Order Confirmed',
                      body: 'Your order #${state.orderId} has been confirmed',
                      type: NotificationType.order,
                      userId: userId,
                    );
                  }
                  context.read<CartBloc>().add(ClearCartEvent());
                } else if (state is CheckoutErrorState) {
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
