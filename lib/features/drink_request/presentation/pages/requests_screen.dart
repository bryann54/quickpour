import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/core/utils/strings.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestsScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final String? initialDrinkName;

  const RequestsScreen({
    super.key,
    this.initialDrinkName,
    required this.authRepository,
  });

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to ensure the context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialDrinkName != null) {
        _showRequestDialog(context);
      }
    });
  }

  void _showRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DrinkRequestDialog(
          authRepository: widget.authRepository,
          initialDrinkName: widget.initialDrinkName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Only fetch requests if user is authenticated
    if (widget.authRepository.isUserSignedIn()) {
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
                'Drink Requests',
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
                if (!widget.authRepository.isUserSignedIn()) {
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
                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Floating hearts background
                                ...List.generate(20, (index) {
                                  final isSmall = index % 2 == 0;
                                  final xOffset = (index * 20 - 140).toDouble();
                                  final startY = index * 30 - 200.0;

                                  return Positioned(
                                    left:
                                        MediaQuery.of(context).size.width / 2 +
                                            xOffset,
                                    top: startY,
                                    child: Icon(
                                      FontAwesomeIcons.beerMugEmpty,
                                      color: isDarkMode
                                          ? AppColors.accentColorDark
                                              .withValues(
                                                  alpha:
                                                      0.5 + (index % 5) * 0.1)
                                          : AppColors.accentColor.withValues(
                                              alpha: 0.5 + (index % 5) * 0.1),
                                      size: isSmall ? 16.0 : 24.0,
                                    )
                                        .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(),
                                        )
                                        .moveY(
                                          begin: 0,
                                          end: 500,
                                          duration: Duration(
                                              seconds: isSmall
                                                  ? 6 + index % 4
                                                  : 8 + index % 5),
                                          curve: Curves.easeInOut,
                                        )
                                        .fadeIn(duration: 600.ms)
                                        .then()
                                        .fadeOut(
                                          begin: 0.7,
                                          delay: Duration(
                                              seconds: isSmall
                                                  ? 5 + index % 3
                                                  : 7 + index % 4),
                                        ),
                                  );
                                }),

                                // Main content
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Animated empty favorites image
                                    Image.asset(
                                      'assets/1212-removebg-preview.png',
                                      width: 200,
                                      height: 150,
                                    ).animate().scale(
                                          begin: const Offset(0.8, 0.8),
                                          end: const Offset(1.0, 1.0),
                                          duration: 800.ms,
                                          curve: Curves.elasticOut,
                                        ),

                                    // Text message with typing animation
                                    Text(
                                      empty_requests,
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                    ).animate().fadeIn(duration: 600.ms).scale(
                                        begin: const Offset(0.8, 0.8),
                                        end: const Offset(1.0, 1.0),
                                        duration: 800.ms,
                                        curve: Curves.elasticOut),
                                    const SizedBox(height: 5),
                                    Text(
                                      request_text,
                                      style: GoogleFonts.lato(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    )
                                        .animate()
                                        .fadeIn(duration: 800.ms)
                                        .slideY(begin: 0.5, duration: 800.ms),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      final request = state.requests[index];
                      return DrinkRequestListTile(
                        request: request,
                        authRepository: widget.authRepository,
                      );
                    },
                  );
                } else if (state is DrinkRequestFailure) {
                  return const Center(
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
      floatingActionButton: widget.authRepository.isUserSignedIn()
          ? FloatingActionButton.extended(
              label: const Text('Make request'),
              onPressed: () => _showRequestDialog(context),
              icon: const Icon(Icons.add),
              tooltip: 'Add Drink Request',
            )
          : null,
    );
  }
}
