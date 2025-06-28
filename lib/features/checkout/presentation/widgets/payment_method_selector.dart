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

  // Color configuration method
  PaymentMethodColors _getColors(BuildContext context, bool isSelected) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isSelected) {
      return PaymentMethodColors(
        backgroundColor: isDark
            ? AppColors.primaryColor.withValues(alpha: 0.1)
            : AppColors.primaryColor.withValues(alpha: 0.05),
        borderColor: AppColors.primaryColor,
        titleColor: isDark ? Colors.white : AppColors.primaryColor,
        subtitleColor: isDark
            ? Colors.white.withValues(alpha: 0.8)
            : AppColors.primaryColor.withValues(alpha: 0.8),
        radioColor: AppColors.primaryColor,
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.2),
      );
    } else {
      return PaymentMethodColors(
        backgroundColor:
            isDark ? theme.cardColor.withValues(alpha: 0.3) : Colors.white,
        borderColor: isDark
            ? theme.dividerColor.withValues(alpha: 0.3)
            : theme.dividerColor,
        titleColor: theme.textTheme.bodyLarge?.color ?? Colors.black,
        subtitleColor: theme.textTheme.bodySmall?.color ?? Colors.grey,
        radioColor: theme.unselectedWidgetColor,
        shadowColor: Colors.transparent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context, isSelected);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.borderColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors.shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: AppColors.primaryColor.withValues(alpha: 0.1),
          highlightColor: AppColors.primaryColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? Colors.white
                        : Colors.grey.withValues(alpha: 0.1),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      iconPath,
                      width: 44,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Payment method details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with enhanced styling
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: colors.titleColor,
                          letterSpacing: 0.2,
                        ),
                        child: Text(title),
                      ),
                      const SizedBox(height: 6),

                      // Subtitle with enhanced styling
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.subtitleColor,
                          height: 1.4,
                        ),
                        child: Text(subtitle),
                      ),
                    ],
                  ),
                ),

                // Enhanced radio button
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isSelected ? 1.1 : 1.0,
                  child: Radio<CheckoutPaymentMethod>(
                    value: method,
                    groupValue: isSelected ? method : null,
                    onChanged: (_) => onTap(),
                    activeColor: colors.radioColor,
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return colors.radioColor;
                      }
                      return colors.radioColor.withValues(alpha: 0.6);
                    }),
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper class for color management
class PaymentMethodColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color radioColor;
  final Color shadowColor;

  const PaymentMethodColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.radioColor,
    required this.shadowColor,
  });
}
