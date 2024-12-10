import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'merchants_event.dart';
part 'merchants_state.dart';

class MerchantsBloc extends Bloc<MerchantsEvent, MerchantsState> {
  MerchantsBloc() : super(MerchantsInitial()) {
    on<MerchantsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
