import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final deliveryTime = DateTime.parse(offer['deliveryTime']);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Store:'),
                const SizedBox(width: 12),
                Text(
                  offer['storeName'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                const Text('Store location:'),
                const SizedBox(width: 12),
                Text(
                  offer['location'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Delivery by: ${DateFormat('h:mm a').format(deliveryTime)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (offer['notes']?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(.2),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  offer['notes'],
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(.11),
                        )),
                    child: Text(
                      'Total: Ksh ${offer['price'].toStringAsFixed(0)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDarkMode
                            ? AppColors.background
                            : AppColors.backgroundDark,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Space between the items
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? AppColors.background
                          : theme.colorScheme.primaryContainer,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isDarkMode
                              ? AppColors.background
                              : AppColors.backgroundDark,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Your onPressed function here
                    },
                    icon: Icon(
                      Icons.local_offer_outlined,
                      color: isDarkMode
                          ? AppColors.backgroundDark
                          : AppColors.background,
                    ),
                    label: Text(
                      'Accept offer',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDarkMode
                            ? AppColors.backgroundDark
                            : AppColors.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
