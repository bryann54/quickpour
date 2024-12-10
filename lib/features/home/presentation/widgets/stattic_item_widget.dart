
import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileStatisticItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;

  const ProfileStatisticItem({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentColor, size: 28),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
