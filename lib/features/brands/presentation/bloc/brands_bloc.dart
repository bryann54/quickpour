import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'brands_event.dart';
part 'brands_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  BrandsBloc() : super(BrandsInitial()) {
    on<BrandsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
