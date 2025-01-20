import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/drink_request/data/repositories/drink_request_repository.dart';
import 'package:chupachap/features/drink_request/presentation/bloc/drink_request_state.dart';
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
        final requests = await repository.getDrinkRequests();
        emit(DrinkRequestSuccess(requests));
      } catch (e) {
        if (e.toString().contains('User not authenticated')) {
          emit(DrinkRequestFailure('Please login to view your requests'));
        } else {
          emit(DrinkRequestFailure(e.toString()));
        }
      }
    });

    on<DeleteDrinkRequest>((event, emit) async {
      try {
        emit(DrinkRequestLoading());
        await repository.deleteDrinkRequest(event.id);
        add(FetchDrinkRequests());
      } catch (e) {
        emit(DrinkRequestFailure(e.toString()));
      }
    });

    on<LoadOffers>((event, emit) async {
      try {
        emit(DrinkRequestLoading());
        final offers = await repository.getOffers(event.requestId);
        emit(OffersLoaded(offers));
      } catch (e) {
        emit(DrinkRequestFailure(e.toString()));
      }
    });
  }
}
