import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MerchantTileShimmer extends StatelessWidget {
  const MerchantTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkTheme ? Colors.grey[400]! : Colors.grey[400]!;
    final highlightColor = isDarkTheme ? Colors.grey[500]! : Colors.grey[100]!;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Shimmer for Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[600],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shimmer for Name
                        Container(
                          width: double.infinity,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        // Shimmer for Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: baseColor,
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 150,
                              height: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Shimmer for Store Status
                        Container(
                          width: 100,
                          height: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Shimmer for Rating
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    width: 60,
                    height: 30,
                    color: Colors.white,
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
