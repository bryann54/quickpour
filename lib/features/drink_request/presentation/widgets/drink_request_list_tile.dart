// widgets/drink_request_list_tile.dart
import 'package:chupachap/features/drink_request/data/models/drink_request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrinkRequestListTile extends StatelessWidget {
  final DrinkRequest request;

  DrinkRequestListTile({required this.request});

  @override
  Widget build(BuildContext context) {
    // Format timestamp for better readability
    final formattedTime =
        DateFormat('yyyy-MM-dd – hh:mm a').format(request.timestamp);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(Icons.local_drink, color: Theme.of(context).primaryColor),
        title: Text(
          request.drinkName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quantity: ${request.quantity}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              'Requested on: $formattedTime',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[500],
        ),
        onTap: () {
          // Action when tapped (could be viewing details)
        },
      ),
    );
  }
}
