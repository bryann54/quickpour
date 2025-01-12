// blocs/drink_request/drink_request_event.dart
import 'package:chupachap/features/drink_request/data/models/drink_request.dart';

abstract class DrinkRequestEvent {}

class AddDrinkRequest extends DrinkRequestEvent {
  final DrinkRequest request;
  AddDrinkRequest(this.request);
}

class FetchDrinkRequests extends DrinkRequestEvent {}

