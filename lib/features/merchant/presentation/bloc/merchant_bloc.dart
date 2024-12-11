import 'package:bloc/bloc.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
part 'merchant_event.dart';
part 'merchant_state.dart';


class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  final MerchantsRepository merchantRepository;

  MerchantBloc(this.merchantRepository) : super(MerchantInitial()) {
    on<FetchMerchantEvent>((event, emit) async {
      emit(MerchantLoading());
      try {
        final merchants = await merchantRepository.getMerchants();
        emit(MerchantLoaded(merchants));
      } catch (e) {
        emit(MerchantError(e.toString()));
      }
    }
    );
  }
}
