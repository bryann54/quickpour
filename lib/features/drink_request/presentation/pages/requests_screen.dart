// screens/requests_screen.dart
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_bloc.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_event.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_state.dart';
import 'package:chupachap/features/drink_request/presentation/widgets/drink_request_dialog.dart';
import 'package:chupachap/features/drink_request/presentation/widgets/drink_request_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<DrinkRequestBloc>().add(FetchDrinkRequests());

    return Scaffold(
      appBar: CustomAppBar(
        showProfile: false,
      ),
      body: BlocBuilder<DrinkRequestBloc, DrinkRequestState>(
        builder: (context, state) {
          if (state is DrinkRequestLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DrinkRequestSuccess) {
            return ListView.builder(
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return DrinkRequestListTile(request: request);
              },
            );
          } else if (state is DrinkRequestFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(child: Text('No requests found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRequestDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add Drink Request',
      ),
    );
  }

  void _showRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DrinkRequestDialog();
      },
    );
  }
}
