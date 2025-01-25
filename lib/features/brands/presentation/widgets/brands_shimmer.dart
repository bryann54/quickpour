import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BrandsScreenShimmer extends StatelessWidget {
  const BrandsScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 9, // Number of shimmer items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8, // Adjust to match card aspect ratio
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const SizedBox(height: 12),
                // Placeholder for text
                Container(
                  height: 16,
                  width: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 60,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
