
import 'package:chupachap/core/utils/colors.dart';

import 'package:chupachap/features/Merchant/presentation/widgets/horizontal_avatar_widget.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:flutter/material.dart';

class HorizontalMerchantsListWidget extends StatelessWidget {
  final List<Merchants> merchant;
  const HorizontalMerchantsListWidget({super.key, required this.merchant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Filter only verified Merchants
    final verifiedMerchants =
        merchant.where((merchant) => merchant.isVerified).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.dividerColorDark.withOpacity(.3)
              : AppColors.cardColor.withOpacity(.5),
          borderRadius:
              BorderRadius.circular(12), 
        ),
        child: verifiedMerchants.isEmpty
            ? const Center(
                child: Text(
                  'No verified Merchants available',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    MerchantCardAvatar(merchant: verifiedMerchants[index]),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: verifiedMerchants.length,
              ),
      ),
    );
  }
}
