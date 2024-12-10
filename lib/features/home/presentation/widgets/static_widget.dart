
import 'package:chupachap/features/home/presentation/widgets/stattic_item_widget.dart';
import 'package:flutter/material.dart';

class ProfileStatisticsSection extends StatelessWidget {
  const ProfileStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const ProfileStatisticItem(
              icon: Icons.favorite_rounded,
              label: "Matches",
              count: "28",
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: VerticalDivider(
                color: Colors.grey[200],
                thickness: 2.0,
              ),
            ),
            const ProfileStatisticItem(
              icon: Icons.chat_bubble_rounded,
              label: "Chats",
              count: "15",
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: VerticalDivider(
                color: Colors.grey[200],
                thickness: 2.0,
              ),
            ),
            const ProfileStatisticItem(
              icon: Icons.visibility_rounded,
              label: "Profile Views",
              count: "142",
            ),
          ],
        ),
      ),
    );
  }
}
