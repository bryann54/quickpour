import 'package:chupachap/features/drink_request/data/models/drink_request.dart';

abstract class DrinkRequestEvent {}

class AddDrinkRequest extends DrinkRequestEvent {
  final DrinkRequest request;
  AddDrinkRequest(this.request);
}

class FetchDrinkRequests extends DrinkRequestEvent {}

class DeleteDrinkRequest extends DrinkRequestEvent {
  final String id;
  DeleteDrinkRequest(this.id);
}
