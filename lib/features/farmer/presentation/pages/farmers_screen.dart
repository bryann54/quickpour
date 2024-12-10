
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/farmer/presentation/bloc/farmer_bloc.dart';
import 'package:chupachap/features/farmer/presentation/bloc/farmer_state.dart';
import 'package:chupachap/features/farmer/presentation/pages/farmer_details_screen.dart';
import 'package:chupachap/features/farmer/presentation/widgets/farmer_card_widget.dart';
import 'package:chupachap/features/farmer/presentation/widgets/farmer_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FarmersScreen extends StatelessWidget {
  const FarmersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: BlocBuilder<FarmerBloc, FarmerState>(
        builder: (context, state) {
          if (state is FarmerLoading) {
            return const Center(child: FarmersShimmer());
          } else if (state is FarmerLoaded) {
            return Column(
              children: [
                Text(
                  'Farmers',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.farmers.length,
                    itemBuilder: (context, index) {
                      final farmer = state.farmers[index];
                      return FarmerCardWidget(
                        farmer: farmer,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FarmerDetailsScreen(farmer: farmer)));
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is FarmerError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
