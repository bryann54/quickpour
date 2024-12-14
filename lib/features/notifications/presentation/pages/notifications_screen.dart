import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Order Confirmed',
      'description': 'Your order #1234 has been confirmed.',
      'time': '2 min ago',
      'icon': 'assets/icons/confirmed.png',
    },
    {
      'title': 'Drink Discount!',
      'description': '50% off on your favorite soda this weekend.',
      'time': '1 hr ago',
      'icon': 'assets/icons/discount.png',
    },
    {
      'title': 'Order Delivered',
      'description': 'Your order #1234 has been delivered.',
      'time': 'Yesterday',
      'icon': 'assets/icons/delivered.png',
    },
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter or settings logic
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(theme)
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(notification['icon']!),
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                  title: Text(
                    notification['title']!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(notification['description']!),
                  trailing: Text(
                    notification['time']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  onTap: () {
                    // Handle notification tap
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: theme.colorScheme.onBackground.withOpacity(0.2),
          ),
          const SizedBox(height: 20),
          Text(
            'No Notifications Yet',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'We\'ll let you know when something comes up.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
