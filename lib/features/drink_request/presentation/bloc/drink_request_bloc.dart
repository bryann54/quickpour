// blocs/drink_request/drink_request_bloc.dart
import 'package:chupachap/features/drink_request/data/repositories/drink_request_repository.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'drink_request_event.dart';

class DrinkRequestBloc extends Bloc<DrinkRequestEvent, DrinkRequestState> {
  final DrinkRequestRepository repository;

  DrinkRequestBloc(this.repository) : super(DrinkRequestInitial()) {
    on<AddDrinkRequest>((event, emit) async {
      try {
        emit(DrinkRequestLoading());
        await repository.addDrinkRequest(event.request);
        add(FetchDrinkRequests());
      } catch (e) {
        emit(DrinkRequestFailure(e.toString()));
      }
    });

    on<FetchDrinkRequests>((event, emit) async {
      try {
        emit(DrinkRequestLoading());
        final requests = await repository.fetchDrinkRequests();
        emit(DrinkRequestSuccess(requests));
      } catch (e) {
        emit(DrinkRequestFailure(e.toString()));
      }
    });
  }
}
