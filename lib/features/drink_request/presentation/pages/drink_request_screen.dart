import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:flutter/material.dart';

class DrinkRequestScreen extends StatelessWidget {
  const DrinkRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Drink request',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          const Text('Item 2'),
          const Text('Item 3'),
        ],
      ),
    );
  }
}
