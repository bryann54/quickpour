import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/drink_request/data/models/drink_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_bloc.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_event.dart';
import 'package:intl/intl.dart';

class DrinkRequestDialog extends StatefulWidget {
  final AuthRepository authRepository;
  final String? initialDrinkName;

  const DrinkRequestDialog({
    super.key,
    this.initialDrinkName,
    required this.authRepository,
  });

  @override
  State<DrinkRequestDialog> createState() => _DrinkRequestDialogState();
}

class _DrinkRequestDialogState extends State<DrinkRequestDialog> {
  @override
  void initState() {
    super.initState();
    // Prefill the drink name if provided
    if (widget.initialDrinkName != null) {
      _drinkNameController.text = widget.initialDrinkName!;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _drinkNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _instructionsController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _drinkNameController.dispose();
    _quantityController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 14)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandPrimary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.brandPrimary,
                onPrimary: Colors.white,
                surface: AppColors.surface,
                onSurface: AppColors.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _submitRequest(BuildContext context) {
    if (!_formKey.currentState!.validate() || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final userId = widget.authRepository.getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to create a request'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final drinkRequest = DrinkRequest(
      id: DateTime.now().toIso8601String(),
      drinkName: _drinkNameController.text.trim(),
      userId: userId, // Add the user ID here
      quantity: int.parse(_quantityController.text),
      timestamp: DateTime.now(),
      merchantId: '',
      additionalInstructions: _instructionsController.text.trim(),
      preferredTime: _selectedDateTime!,
    );

    context.read<DrinkRequestBloc>().add(AddDrinkRequest(drinkRequest));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Drink Request',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _drinkNameController,
                decoration: InputDecoration(
                  hintText: 'Drink name',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (int.tryParse(value!) == null || int.parse(value) <= 0) {
                    return 'Invalid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Additional instructions (optional)',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDateTime(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDateTime == null
                              ? 'Select delivery time'
                              : DateFormat('MMM d, y • h:mm a')
                                  .format(_selectedDateTime!),
                          style: TextStyle(
                            color: _selectedDateTime == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _submitRequest(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
