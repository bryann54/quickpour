// custom_greeting.dart
import 'package:chupachap/features/user_data/presentation/bloc/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGreeting extends StatelessWidget {
  const CustomGreeting({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 4) {
      return 'Good night';
    } else if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else if (hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoading) {
          return Row(
            children: [
              const CircularProgressIndicator.adaptive(),
              const SizedBox(width: 16),
              Text(
                'Fetching data...',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          );
        }

        if (state is UserDataError) {
          return Text(
            '${_getGreeting()},👋 ',
            style: GoogleFonts.instrumentSerif(
              textStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          );
        }

        if (state is UserDataLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()}, ${state.userData.name}!',
                style: GoogleFonts.instrumentSerif(
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    size: 15,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.userData.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Text(
          _getGreeting(),
          style: theme.textTheme.titleLarge,
        );
      },
    );
  }
}
