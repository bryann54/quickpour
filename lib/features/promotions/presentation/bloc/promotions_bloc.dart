import 'package:chupachap/features/promotions/presentation/bloc/promotions_event.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/promotions/data/repositories/promotions_repository.dart';

class PromotionsBloc extends Bloc<PromotionsEvent, PromotionsState> {
  final PromotionsRepository promotionsRepository;

  PromotionsBloc({required this.promotionsRepository})
      : super(PromotionsInitial()) {
    on<FetchActivePromotions>(_onFetchActivePromotions);
  }

  Future<void> _onFetchActivePromotions(
    FetchActivePromotions event,
    Emitter<PromotionsState> emit,
  ) async {
    emit(PromotionsLoading());

    try {
      final promotions = await promotionsRepository.fetchActivePromotions();
      emit(PromotionsLoaded(promotions));
    } catch (e) {
      emit(PromotionsError('Failed to fetch promotions: ${e.toString()}'));
    }
  }
}
