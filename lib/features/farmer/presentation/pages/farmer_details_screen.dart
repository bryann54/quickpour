
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/farmer/data/models/farmer_model.dart';
import 'package:flutter/material.dart';

class FarmerDetailsScreen extends StatelessWidget {
  final Farmer farmer;

  const FarmerDetailsScreen({Key? key, required this.farmer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                _buildProfileHeader(context),
                const SizedBox(height: 32),
                _buildStatisticsSection(context),
                const SizedBox(height: 32),
                _buildCropsSection(context),
                const SizedBox(height: 32),
                _buildAdditionalInfo(context),
                const SizedBox(height: 32),
                _buildContactButtons(context),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor:
          isDarkMode ? Colors.grey[900] : Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        title: Text(
          farmer.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                blurRadius: 12.0,
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        background: Hero(
          tag: 'farmer_${farmer.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                farmer.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 120,
                      color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    ),
                  );
                },
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (farmer.isVerified)
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified,
                  color: AppColors.accentColor,
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  'Verified',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              farmer.location,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Professional Farmer',
          style: theme.textTheme.titleSmall?.copyWith(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  Colors.grey[800]!,
                  Colors.grey[900]!,
                ]
              : [
                  Colors.green[50]!,
                  Colors.green[100]!,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.accentColor.withOpacity(0.2)
                : Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context: context,
            icon: Icons.agriculture,
            label: 'Experience',
            value: '${farmer.experience}y',
            iconColor: isDarkMode ? Colors.green[400]! : Colors.green[700]!,
          ),
          _buildDivider(context),
          _buildStatItem(
            context: context,
            icon: Icons.star,
            label: 'Rating',
            value: farmer.rating.toStringAsFixed(1),
            iconColor: isDarkMode ? Colors.amber[400]! : Colors.amber[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      height: 120,
      width: 3,
      color: isDarkMode ? Colors.grey[700] : Colors.green[700],
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(isDarkMode ? 0.1 : 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 28,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCropsSection(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specializes in',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: farmer.crops.map((crop) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(isDarkMode ? 0.1 : 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.green[100]!,
                  width: 1,
                ),
              ),
              child: Text(
                crop,
                style: TextStyle(
                  color: isDarkMode ? Colors.green[300] : Colors.green[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(isDarkMode ? 0.1 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Professional farmer with ${farmer.experience} years of experience in sustainable farming practices. Specialized in organic farming and crop rotation techniques.',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButtons(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement message functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? Colors.grey[800]
                  : Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
            ),
            icon: const Icon(Icons.message),
            label: const Text(
              'Message',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.green[50],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(isDarkMode ? 0.1 : 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              // TODO: Implement call functionality
            },
            icon: Icon(
              Icons.phone,
              color: isDarkMode
                  ? Colors.green[300]
                  : Theme.of(context).primaryColor,
              size: 28,
            ),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
