import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_bloc.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_event.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_state.dart';
import 'package:chupachap/features/drink_request/presentation/widgets/drink_request_dialog.dart';
import 'package:chupachap/features/drink_request/presentation/widgets/drink_request_list_tile.dart';
import 'package:chupachap/features/drink_request/presentation/widgets/drink_request_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestsScreen extends StatelessWidget {
  final AuthRepository authRepository;

  const RequestsScreen({
    super.key,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Only fetch requests if user is authenticated
    if (authRepository.isUserSignedIn()) {
      context.read<DrinkRequestBloc>().add(FetchDrinkRequests());
    }

    return Scaffold(
      appBar: CustomAppBar(
        showProfile: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Requests',
                style: GoogleFonts.montaga(
                  textStyle: theme.textTheme.displayLarge?.copyWith(
                    color: isDarkMode
                        ? AppColors.cardColor
                        : AppColors.accentColorDark,
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
            ),
          ),
          Expanded(
            child: BlocBuilder<DrinkRequestBloc, DrinkRequestState>(
              builder: (context, state) {
                // Check authentication status
                if (!authRepository.isUserSignedIn()) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Please log in to view your requests',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to login screen or show login dialog
                            // Implement your navigation logic here
                          },
                          child: const Text('Log In'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is DrinkRequestLoading) {
                  return const Center(child: DrinkRequestListTileShimmer());
                } else if (state is DrinkRequestSuccess) {
                  if (state.requests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_drink_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No requests yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      final request = state.requests[index];
                      return DrinkRequestListTile(
                        request: request,
                        authRepository: authRepository,
                      );
                    },
                  );
                } else if (state is DrinkRequestFailure) {
                 
              return Center(
                    child: Text('error getting requests'),
                  );

                 

                  
                } else {
                  return const Center(child: Text('No requests found.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: authRepository.isUserSignedIn()
          ? FloatingActionButton.extended(
              label: const Text('Make request'),
              onPressed: () => _showRequestDialog(context),
              icon: const Icon(Icons.add),
              tooltip: 'Add Drink Request',
            )
          : null,
    );
  }

  void _showRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DrinkRequestDialog(
          authRepository: authRepository,
        );
      },
    );
  }
}
