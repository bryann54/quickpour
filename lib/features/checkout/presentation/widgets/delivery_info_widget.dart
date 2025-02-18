// import 'package:flutter/material.dart';

// class DeliveryInformationSection extends StatelessWidget {
//   final TextEditingController addressController;
//   final TextEditingController phoneController;
//   final bool isDarkMode;

//   const DeliveryInformationSection({
//     required this.addressController,
//     required this.phoneController,
//     required this.isDarkMode,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Delivery Information'),
//         Card(
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: addressController,
//                   decoration: const InputDecoration(
//                     labelText: 'Delivery Address',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                   validator: (value) =>
//                       value?.isEmpty ?? true ? 'Enter delivery address' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: phoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number',
//                     border: OutlineInputBorder(),
//                     prefixText: '+254 ',
//                   ),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) =>
//                       value?.isEmpty ?? true ? 'Enter phone number' : null,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: isDarkMode ? Colors.white : Colors.black,
//         ),
//       ),
//     );
//   }
// }
