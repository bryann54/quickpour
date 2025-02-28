import 'package:chupachap/core/utils/functions.dart';
import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;

  const WalletBalanceCard({
    Key? key,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: 220, // Fixed height for better proportions
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/111.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [
                            Colors.black.withOpacity(0.5),
                            Colors.grey.shade900.withOpacity(0.6),
                            Colors.black.withOpacity(0.7),
                          ]
                        : [
                            Colors.cyan.shade600.withOpacity(0.3),
                            Colors.black.withOpacity(0.8),
                            Colors.cyan.shade600.withOpacity(0.3),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Pattern overlay (optional)
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/111.png', // Add this pattern to your assets
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card logo or app name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ChupaPay',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Icon(
                        Icons.wallet,
                        color: Colors.white.withOpacity(0.9),
                        size: 24,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Current Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ksh ${formatMoney(balance)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.add,
                        label: 'Add Funds',
                        onTap: () {
                          // Navigate to add funds screen
                          // We'll handle this from the parent widget
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        icon: Icons.swap_horiz,
                        label: 'Transfer',
                        onTap: () {
                          // Navigate to transfer screen
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.cyan.shade800,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 3,
        shadowColor: Colors.black38,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

