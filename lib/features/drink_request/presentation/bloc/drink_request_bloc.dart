import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drink_request_event.dart';
part 'drink_request_state.dart';

class DrinkRequestBloc extends Bloc<DrinkRequestEvent, DrinkRequestState> {
  DrinkRequestBloc() : super(DrinkRequestInitial()) {
    on<DrinkRequestEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
