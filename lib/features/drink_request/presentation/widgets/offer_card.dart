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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoreInfo(theme),
            const SizedBox(height: 12),
            _buildLocationInfo(theme),
            const SizedBox(height: 12),
            _buildDeliveryInfo(theme),
            if (offer['notes']?.isNotEmpty ?? false) _buildNotesSection(theme),
            const SizedBox(height: 16),
            _buildActionButtons(theme, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreInfo(ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.storefront, size: 20, color: Colors.blue),
        const SizedBox(width: 10),
        Text(
          offer['storeName'],
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 20,
          color: Colors.green.shade600,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            offer['location'],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfo(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 20,
          color: Colors.orange.shade600,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Delivery by: ${DateFormat('MMM d, h:mm a').format(
              DateTime.parse(offer['deliveryTime']),
            )}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        offer['notes'],
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Total: Ksh ${offer['price'].toStringAsFixed(0)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 16),
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
              color:
                  isDarkMode ? AppColors.backgroundDark : AppColors.background,
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
    );
  }
}
