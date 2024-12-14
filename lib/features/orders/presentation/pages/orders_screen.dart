import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showCart: false,
      ),
      body: _buildEmptyOrdersView(context),
    );
  }

  Widget _buildEmptyOrdersView(BuildContext context) {
    // final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.boxOpen,
            size: 50,
            color: AppColors.brandAccent,
          ),
          SizedBox(height: 20),
          Text('No orders yet',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 150),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (_) => SearchPage()));
          //     },
          //     child: Container(
          //       height: 50,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(5),
          //           color: isDarkMode
          //               ? AppColors.background.withOpacity(.8)
          //               : AppColors.backgroundDark),
          //       child: Center(
          //         child: Text(
          //           'Search Page',
          //           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //                 color: isDarkMode
          //                     ? AppColors.backgroundDark
          //                     : AppColors.background,
          //               ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
