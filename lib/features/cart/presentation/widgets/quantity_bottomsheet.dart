import 'package:flutter/material.dart';

class QuantityPickerBottomSheet extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onQuantityChanged;

  const QuantityPickerBottomSheet({
    super.key,
    required this.initialQuantity,
    required this.onQuantityChanged,
  });

  @override
  State<QuantityPickerBottomSheet> createState() =>
      _QuantityPickerBottomSheetState();
}

class _QuantityPickerBottomSheetState extends State<QuantityPickerBottomSheet> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider for Quantity
          Slider(
            value: _quantity.toDouble(),
            min: 1,
            max: 100,
            divisions: 99,
            label: _quantity.toString(),
            onChanged: (value) {
              setState(() {
                _quantity = value.toInt();
              });
            },
          ),

          // Display Selected Quantity
          Text(
            'Quantity: $_quantity',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          // Confirm Button
          ElevatedButton(
            onPressed: () {
              widget.onQuantityChanged(_quantity);
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
