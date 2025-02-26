import 'package:chupachap/features/promotions/presentation/bloc/promotions_bloc.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_state.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
      ),
      body: BlocBuilder<PromotionsBloc, PromotionsState>(
        builder: (context, state) {
          if (state is PromotionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PromotionsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is PromotionsLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(
                  10.0), // Added padding for better spacing
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: state.promotions.length,
              itemBuilder: (context, index) {
                final promotion = state.promotions[index];
                return PromoCard(promotion: promotion);
              },
            );
          }
          return const Center(child: Text('No promotions available'));
        },
      ),
   
    );
  }
}