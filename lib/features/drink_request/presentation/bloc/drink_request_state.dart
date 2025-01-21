// blocs/drink_request/drink_request_state.dart
import 'package:chupachap/features/drink_request/data/models/drink_request.dart';

abstract class DrinkRequestState {}

class DrinkRequestInitial extends DrinkRequestState {}

class DrinkRequestLoading extends DrinkRequestState {}

class DrinkRequestSuccess extends DrinkRequestState {
  final List<DrinkRequest> requests;
  DrinkRequestSuccess(this.requests);
}

class DrinkRequestFailure extends DrinkRequestState {
  final String error;
  DrinkRequestFailure(this.error);
}

class OffersLoaded extends DrinkRequestState {
  final List<Map<String, dynamic>> offers;

  OffersLoaded(this.offers);
}
// class OffersStreamLoadingState extends DrinkRequestState {}

// class OffersStreamLoadedState extends DrinkRequestState {
//   final List<Map<String, dynamic>> offers;
//   OffersStreamLoadedState(this.offers);
// }
