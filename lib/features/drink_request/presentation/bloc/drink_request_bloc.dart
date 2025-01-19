import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/drink_request/data/repositories/drink_request_repository.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_event.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_state.dart';

class DrinkRequestBloc extends Bloc<DrinkRequestEvent, DrinkRequestState> {
  final DrinkRequestRepository repository;

  DrinkRequestBloc(this.repository) : super(DrinkRequestInitial()) {
    on<AddDrinkRequest>((event, emit) async {
      emit(DrinkRequestLoading());
      try {
        await repository.addDrinkRequest(event.request);
        add(FetchDrinkRequests());
      } catch (e) {
        emit(DrinkRequestFailure(
            'Failed to add drink request: ${e.toString()}'));
      }
    });

    on<FetchDrinkRequests>((event, emit) async {
      emit(DrinkRequestLoading());
      try {
        final requests = await repository.fetchDrinkRequests();
        emit(DrinkRequestSuccess(requests));
      } catch (e) {
        emit(DrinkRequestFailure(
            'Failed to fetch drink requests: ${e.toString()}'));
      }
    });

    on<DeleteDrinkRequest>((event, emit) async {
      emit(DrinkRequestLoading());
      try {
        await repository.deleteDrinkRequest(event.id);
        add(FetchDrinkRequests());
      } catch (e) {
        emit(DrinkRequestFailure(
            'Failed to delete drink request: ${e.toString()}'));
      }
    });

    on<FetchOffersEvent>((event, emit) async {
      emit(DrinkRequestLoading());
      try {
        final offers = await repository.getOffers(event.requestId);
        emit(OffersLoadedState(offers));
      } catch (e) {
        emit(DrinkRequestFailure('Failed to load offers: ${e.toString()}'));
      }
    });
  }
}
