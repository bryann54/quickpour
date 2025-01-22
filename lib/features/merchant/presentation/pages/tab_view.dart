import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/brands/presentation/pages/brands_screen.dart';
import 'package:chupachap/features/categories/presentation/pages/categories_screen.dart';
import 'package:chupachap/features/merchant/presentation/pages/merchants_screen.dart';
import 'package:flutter/material.dart';

class StoreTabsScreen extends StatelessWidget {
  const StoreTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          toolbarHeight: 70.0,
        
          showNotification: true,
          showCart: true,
          showProfile: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0), 
            child: TabBar(
              tabs: const [
                Tab(text: 'Stores'),
                Tab(text: 'Brands'),
                Tab(text: 'Categories'),
              ],
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? AppColors.background : AppColors.backgroundDark,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: isDarkMode
                    ? AppColors.brandAccent
                    : AppColors.shadowColorDark,
              ),
              padding: const EdgeInsets.only(
                  bottom: 8), 
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            MerchantsScreen(),
            BrandsScreen(),
            CategoriesScreen(),
          ],
        ),
      ),
    );
  }
}
