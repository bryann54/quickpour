import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingHorizontalList extends StatelessWidget {
  final double? width;
  const LoadingHorizontalList({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[200]!,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 80,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                    width: width ?? 130,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemCount: 10),
        ),
      ),
    );
  }
}
