import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFundsScreen extends StatefulWidget {
  final String paymentMethodId;

  const AddFundsScreen({Key? key, required this.paymentMethodId})
      : super(key: key);

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<double> _quickAmounts = [250, 500, 1000, 2500, 5000];
  double _selectedAmount = 0.0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Funds'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: isDarkMode
                    ? Colors.grey.withValues(alpha: .1)
                    : Colors.grey[100],
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _selectedAmount = double.tryParse(value) ?? 0.0;
                  });
                } else {
                  setState(() {
                    _selectedAmount = 0.0;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick Amounts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _quickAmounts.map((amount) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.grey.withValues(alpha: .1)
                        : AppColors.glassEffect.withValues(alpha: .2),
                    foregroundColor: isDarkMode
                        ? Colors.white.withValues(alpha: .6)
                        : AppColors.primaryColor.withValues(alpha: .8),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedAmount = amount;
                      _amountController.text = amount.toString();
                    });
                  },
                  child: Text('Ksh ${formatMoney(amount)}'),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? AppColors.brandPrimary
                      : AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _selectedAmount > 0
                    ? () {
                        context.read<WalletBloc>().add(
                              AddFundsEvent(
                                _selectedAmount,
                                widget.paymentMethodId,
                              ),
                            );
                        Navigator.pop(context);
                      }
                    : null,
                child: Text(
                  'Add Ksh ${formatMoney(_selectedAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
