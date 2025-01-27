import 'package:bloc/bloc.dart';
import 'package:chupachap/features/user_data/domain/entities/user_data.dart';
import 'package:chupachap/features/user_data/domain/repositories/user_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final UserDataRepository _repository;

  UserDataBloc({
    required UserDataRepository repository,
  })  : _repository = repository,
        super(UserDataInitial()) {
    on<FetchUserData>(_onFetchUserData);
    on<UpdateUserData>(_onUpdateUserData);
  }

  Future<void> _onFetchUserData(
    FetchUserData event,
    Emitter<UserDataState> emit,
  ) async {
    if (state is UserDataLoaded) return;

    emit(UserDataLoading());

    try {
      final userData = await _repository.getUserData();
      emit(UserDataLoaded(userData));
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> _onUpdateUserData(
    UpdateUserData event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoaded(event.userData));
  }
}
