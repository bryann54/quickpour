import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:flutter/material.dart';

enum CheckoutPaymentMethod {
  wallet,
  mpesa,
  cashOnDelivery,
  creditCard,
}

class PaymentMethodSelector extends StatelessWidget {
  final CheckoutPaymentMethod selectedMethod;
  final Function(CheckoutPaymentMethod) onMethodChanged;
  final double walletBalance;
  final double orderTotal;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.walletBalance,
    required this.orderTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Wallet option (if balance is sufficient)
        if (walletBalance >= orderTotal)
          PaymentMethodTile(
            method: CheckoutPaymentMethod.wallet,
            title: 'Wallet Balance',
            iconPath: 'assets/111.png',
            subtitle:
                'Pay using your ChupaPay balance: Ksh ${formatMoney(walletBalance)}',
            isSelected: selectedMethod == CheckoutPaymentMethod.wallet,
            onTap: () => onMethodChanged(CheckoutPaymentMethod.wallet),
          ),

        if (walletBalance >= orderTotal) const SizedBox(height: 12),

        // M-Pesa option
        PaymentMethodTile(
          method: CheckoutPaymentMethod.mpesa,
          title: 'M-Pesa',
          iconPath: 'assets/M-PESA.png',
          subtitle: 'Pay securely with M-Pesa',
          isSelected: selectedMethod == CheckoutPaymentMethod.mpesa,
          onTap: () => onMethodChanged(CheckoutPaymentMethod.mpesa),
        ),
        const SizedBox(height: 12),

        // Cash on Delivery option
        PaymentMethodTile(
          method: CheckoutPaymentMethod.cashOnDelivery,
          title: 'Cash on Delivery',
          iconPath: 'assets/cod.png',
          subtitle: 'Pay when you receive your order',
          isSelected: selectedMethod == CheckoutPaymentMethod.cashOnDelivery,
          onTap: () => onMethodChanged(CheckoutPaymentMethod.cashOnDelivery),
        ),
        const SizedBox(height: 12),

        // Credit Card option (commented out)
        // PaymentMethodTile(
        //   method: CheckoutPaymentMethod.creditCard,
        //   title: 'Credit Card',
        //   iconPath: 'assets/card.png',
        //   subtitle: 'Pay with Visa or Mastercard',
        //   isSelected: selectedMethod == CheckoutPaymentMethod.creditCard,
        //   onTap: () => onMethodChanged(CheckoutPaymentMethod.creditCard),
        // ),
      ],
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final CheckoutPaymentMethod method;
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
                // Payment method icon
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

                // Payment method details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Radio button for selection
                Radio<CheckoutPaymentMethod>(
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
