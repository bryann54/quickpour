// widgets/drink_request_dialog.dart
import 'package:chupachap/features/drink_request/data/models/drink_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_bloc.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_event.dart';
import 'package:intl/intl.dart';

class DrinkRequestDialog extends StatefulWidget {
  @override
  _DrinkRequestDialogState createState() => _DrinkRequestDialogState();
}

class _DrinkRequestDialogState extends State<DrinkRequestDialog> {
  final TextEditingController _drinkNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  DateTime? _preferredTime;

  void _submitRequest(BuildContext context) {
    final String drinkName = _drinkNameController.text;
    final int quantity = int.tryParse(_quantityController.text) ?? 0;
    final String instructions = _instructionsController.text;

    if (drinkName.isEmpty || quantity <= 0 || _preferredTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields correctly')),
      );
      return;
    }

    final drinkRequest = DrinkRequest(
      id: DateTime.now().toIso8601String(),
      drinkName: drinkName,
      quantity: quantity,
      timestamp: DateTime.now(),
      merchantId: '', // Merchant field is removed, empty string for now
      additionalInstructions: instructions,
      preferredTime: _preferredTime!,
    );

    context.read<DrinkRequestBloc>().add(AddDrinkRequest(drinkRequest));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Make a Drink Request'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _drinkNameController,
              decoration: InputDecoration(labelText: 'Drink Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _instructionsController,
              decoration: InputDecoration(labelText: 'Additional Instructions'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _preferredTime)
                  setState(() {
                    _preferredTime = picked;
                  });
              },
              child: InputDecorator(
                decoration:
                    InputDecoration(labelText: 'Preferred Delivery Time'),
                child: Text(
                  _preferredTime == null
                      ? 'Select Date'
                      : DateFormat('yyyy-MM-dd').format(_preferredTime!),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _submitRequest(context),
          child: Text('Submit Request'),
        ),
      ],
    );
  }
}
