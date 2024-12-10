
import 'package:chupachap/features/farmer/data/repositories/farmer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'farmer_event.dart';
import 'farmer_state.dart';
class FarmerBloc extends Bloc<FarmerEvent, FarmerState> {
  final FarmerRepository farmerRepository;

  FarmerBloc(this.farmerRepository) : super(FarmerInitial()) {
    on<FetchFarmersEvent>((event, emit) async {
      emit(FarmerLoading());
      try {
        final farmers = await farmerRepository.getFarmers();
        emit(FarmerLoaded(farmers));
      } catch (e) {
        emit(FarmerError(e.toString()));
      }
    });
  }
}
