import 'package:bloc/bloc.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:equatable/equatable.dart';

part 'merchant_event.dart';
part 'merchant_state.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  final MerchantsRepository merchantRepository;

  MerchantBloc(this.merchantRepository) : super(MerchantInitial()) {
    on<FetchMerchantEvent>(_onFetchMerchants);
    on<FetchMoreMerchantsEvent>(_onFetchMoreMerchants);
  }

  Future<void> _onFetchMerchants(
      FetchMerchantEvent event, Emitter<MerchantState> emit) async {
    emit(MerchantLoading());
    try {
      final merchants = await merchantRepository.getMerchants();
      emit(MerchantLoaded(merchants, hasMoreData: merchants.length == 5));
    } catch (e) {
      emit(MerchantError(e.toString()));
    }
  }

  Future<void> _onFetchMoreMerchants(
      FetchMoreMerchantsEvent event, Emitter<MerchantState> emit) async {
    final currentState = state;
    if (currentState is MerchantLoaded && currentState.hasMoreData) {
      try {
        final newMerchants = await merchantRepository.getNextMerchantsPage();
        final allMerchants = List<Merchants>.from(currentState.merchants)
          ..addAll(newMerchants);

        emit(MerchantLoaded(allMerchants,
            hasMoreData: newMerchants.length == 5));
      } catch (e) {
        emit(MerchantError(e.toString()));
      }
    }
  }
}
