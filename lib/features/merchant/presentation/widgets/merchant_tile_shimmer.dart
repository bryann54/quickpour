import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MerchantTileShimmer extends StatelessWidget {
  const MerchantTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkTheme ? Colors.grey[700]! : Colors.grey[300]!;
    final highlightColor = isDarkTheme ? Colors.grey[600]! : Colors.grey[100]!;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile Image Shimmer
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Merchant Details Shimmer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Name Shimmer
                            Expanded(
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Status Indicator Shimmer
                            Container(
                              width: 60,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Location Shimmer
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Rating Shimmer
                        Container(
                          width: 80,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
