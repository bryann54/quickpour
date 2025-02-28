// lib/features/checkout/presentation/widgets/payment_method_selector.dart

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/checkout/presentation/pages/payments_screen.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final Function(PaymentMethod) onMethodChanged;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedMethod,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentMethodTile(
          method: PaymentMethod.mpesa,
          title: 'M-Pesa',
          iconPath: 'assets/M-PESA.png',
          subtitle: 'Pay securely with M-Pesa',
          isSelected: selectedMethod == PaymentMethod.mpesa,
          onTap: () => onMethodChanged(PaymentMethod.mpesa),
        ),
        const SizedBox(height: 12),
        PaymentMethodTile(
          method: PaymentMethod.cashOnDelivery,
          title: 'Cash on Delivery',
          iconPath: 'assets/cod.png',
          subtitle: 'Pay when you receive your order',
          isSelected: selectedMethod == PaymentMethod.cashOnDelivery,
          onTap: () => onMethodChanged(PaymentMethod.cashOnDelivery),
        ),
        const SizedBox(height: 12),
        PaymentMethodTile(
          method: PaymentMethod.creditCard,
          title: 'Credit Card',
          iconPath: 'assets/card.png',
          subtitle: 'Pay with Visa or Mastercard',
          isSelected: selectedMethod == PaymentMethod.creditCard,
          onTap: () => onMethodChanged(PaymentMethod.creditCard),
        ),
      ],
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final String title;
  final String iconPath;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    Key? key,
    required this.method,
    required this.title,
    required this.iconPath,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? (isDark
                  ? AppColors.error.withOpacity(.1)
                  : AppColors.primaryColor)
              : theme.dividerColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: isSelected
            ? AppColors.backgroundDark.withOpacity(.1)
            : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    iconPath,
                    width: 60,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Radio<PaymentMethod>(
                  value: method,
                  groupValue: isSelected ? method : null,
                  onChanged: (_) => onTap(),
                  activeColor:
                      isDark ? Colors.white : theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
