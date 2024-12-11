
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/product/presentation/pages/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showCart: false,),
      body: _buildEmptyOrdersView(context),
    );
  }

  Widget _buildEmptyOrdersView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.clipboardList,
              size: 100, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text('No orders yet',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 150),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductsScreen(),
                ),
              );
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
}
