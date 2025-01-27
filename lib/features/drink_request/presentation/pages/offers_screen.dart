import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/drink_request/data/repositories/drink_request_repository.dart';
import 'package:chupachap/features/drink_request/presentation/widgets/offer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chupachap/features/drink_request/data/models/drink_request.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_bloc.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_event.dart';

class OffersScreen extends StatelessWidget {
  final DrinkRequest request;

  const OffersScreen({
    super.key,
    required this.request,
  });

  Future<List<Map<String, dynamic>>> _fetchOffers() async {
    try {
      final authRepository = AuthRepository();
      final repository = DrinkRequestRepository(authRepository);
      return await repository.getOffers(request.id);
    } catch (e) {
      rethrow; // This will propagate the error to the FutureBuilder
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return await showCupertinoDialog<bool>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Delete Request?'),
              content: Text(
                'Are you sure you want to delete the request for ${request.quantity}x ${request.drinkName}? Any pending offers will be cancelled.',
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete Request?'),
            content: Text(
              'Are you sure you want to delete the request for ${request.quantity}x ${request.drinkName}? Any pending offers will be cancelled.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _handleDelete(BuildContext context) async {
    final shouldDelete = await _showDeleteConfirmation(context);

    if (shouldDelete && context.mounted) {
      context.read<DrinkRequestBloc>().add(DeleteDrinkRequest(request.id));

      // Show success snackbar with undo option
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${request.drinkName} request deleted'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 80), // Account for FAB
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                context.read<DrinkRequestBloc>().add(AddDrinkRequest(request));
              },
            ),
          ),
        );
      }

      // Pop back with fade transition
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            iconTheme: IconThemeData(
                color: isDarkMode
                    ? AppColors.background
                    : AppColors.backgroundDark),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/111.png',
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: Hero(
                tag: 'drink_name_${request.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    request.drinkName,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
              Row(
 mainAxisAlignment: MainAxisAlignment.spaceBetween,
 children: [
   Flexible(
     flex: 1,
     child: Hero(
       tag: 'drink_icon_${request.id}',
       child: ClipRRect(
         borderRadius: BorderRadius.circular(16),
         child: Image.asset(
           'assets/111.png',
           width: 100,
           height: 80,
           fit: BoxFit.cover,
         ),
       ),
     ),
   ),
   const SizedBox(width: 16),
   Flexible(
     flex: 1,
     child: Hero(
       tag: 'quantity_${request.id}',
       child: Container(
         padding: const EdgeInsets.symmetric(
           horizontal: 12,
           vertical: 4,
         ),
         decoration: BoxDecoration(
           color: theme.colorScheme.primaryContainer,
           borderRadius: BorderRadius.circular(20),
         ),
         child: Text(
           'Quantity: ${request.quantity}',
           style: theme.textTheme.titleMedium?.copyWith(
             color: theme.colorScheme.onPrimaryContainer,
             fontWeight: FontWeight.bold,
             fontSize: 12
           ),
           overflow: TextOverflow.ellipsis,
         ),
       ),
     ),
   ),
 ],
),   const SizedBox(height: 16),
                          Hero(
                            tag: 'timestamp_${request.id}',
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(.2),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 20,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  // const Text(' Preffered time:'),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('MMM d, h:mm a')
                                        .format(request.timestamp.toLocal()),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withOpacity(.2),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('additional Instructions',
                                    style: TextStyle(
                                        color: AppColors.accentColor,
                                        fontWeight: FontWeight.bold)),
                                Text(request.additionalInstructions)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Offers',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Corrected FutureBuilder placement inside a container
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchOffers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load offers',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final offer = snapshot.data![index];
                            return OfferCard(offer: offer);
                          },
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              Text(
                                'No offers yet',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          child: FloatingActionButton.extended(
            onPressed: () => _handleDelete(context),
            elevation: 4,
            backgroundColor: theme.colorScheme.errorContainer,
            isExtended: true,
            icon: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  theme.colorScheme.error,
                  theme.colorScheme.onErrorContainer,
                ],
              ).createShader(bounds),
              child: const Icon(Icons.delete_outline),
            ),
            label: Text(
              'Delete Request',
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
