
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/farmer/data/models/farmer_model.dart';
import 'package:chupachap/features/farmer/presentation/widgets/horizontal_avatar_widget.dart';
import 'package:flutter/material.dart';

class HorizontalFarmersListWidget extends StatelessWidget {
  final List<Farmer> farmer;
  const HorizontalFarmersListWidget({super.key, required this.farmer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Filter only verified farmers
    final verifiedFarmers =
        farmer.where((farmer) => farmer.isVerified).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.dividerColorDark.withOpacity(.3)
              : AppColors.cardColor.withOpacity(.5),
          borderRadius:
              BorderRadius.circular(12), // Optional: for rounded corners
        ),
        child: verifiedFarmers.isEmpty
            ? const Center(
                child: Text(
                  'No verified farmers available',
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
                    FarmerCardAvatar(farmer: verifiedFarmers[index]),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: verifiedFarmers.length,
              ),
      ),
    );
  }
}
