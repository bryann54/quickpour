// import 'package:chupachap/core/utils/colors.dart';
// import 'package:chupachap/features/cart/data/models/cart_model.dart';
// import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
// import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
// import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
// import 'package:chupachap/features/product/data/models/product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class PromoQuantityFAB extends StatelessWidget {
//   final ProductModel product;
//   final bool isDarkMode;

//   const PromoQuantityFAB({
//     Key? key,
//     required this.product,
//     required this.isDarkMode,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CartBloc, CartState>(
//       builder: (context, state) {
//         final cartItem = state is CartLoadedState
//             ? state.cart.items.firstWhere(
//                 (item) => item.product.id == product.id,
//                 orElse: () => CartItem(product: product, quantity: 0),
//               )
//             : CartItem(product: product, quantity: 0);

//         if (cartItem.quantity > 0) {
//           return Container(
//             height: 32,
//             constraints: const BoxConstraints(maxWidth: 110),
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? AppColors.background.withOpacity(.2)
//                   : AppColors.accentColor,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.7),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: 32,
//                   height: 32,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: const BorderRadius.horizontal(
//                           left: Radius.circular(16)),
//                       onTap: () {
//                         final newQuantity =
//                             cartItem.quantity > 1 ? cartItem.quantity - 1 : 0;
//                         context.read<CartBloc>().add(
//                               UpdateCartQuantityEvent(
//                                 product: product,
//                                 quantity: newQuantity,
//                               ),
//                             );
//                       },
//                       child: Center(
//                         child: FaIcon(
//                           FontAwesomeIcons.minus,
//                           size: 12,
//                           color:
//                               isDarkMode ? AppColors.accentColor : Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   constraints: const BoxConstraints(minWidth: 24),
//                   alignment: Alignment.center,
//                   child: Text(
//                     '${cartItem.quantity}',
//                     style: TextStyle(
//                       color: isDarkMode ? AppColors.accentColor : Colors.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 32,
//                   height: 32,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: const BorderRadius.horizontal(
//                           right: Radius.circular(16)),
//                       onTap: () {
//                         context.read<CartBloc>().add(
//                               UpdateCartQuantityEvent(
//                                 product: product,
//                                 quantity: cartItem.quantity + 1,
//                               ),
//                             );
//                       },
//                       child: Center(
//                         child: FaIcon(
//                           FontAwesomeIcons.plus,
//                           size: 12,
//                           color:
//                               isDarkMode ? AppColors.accentColor : Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return SizedBox(
//             width: 32,
//             height: 32,
//             child: Material(
//               color: isDarkMode
//                   ? AppColors.background.withOpacity(.2)
//                   : AppColors.accentColor,
//               shape: const CircleBorder(),
//               elevation: 4,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(16),
//                 onTap: () {
//                   context.read<CartBloc>().add(
//                         AddToCartEvent(product: product, quantity: 1),
//                       );
//                 },
//                 child: Center(
//                   child: FaIcon(
//                     FontAwesomeIcons.plus,
//                     size: 14,
//                     color: isDarkMode ? AppColors.accentColor : Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
