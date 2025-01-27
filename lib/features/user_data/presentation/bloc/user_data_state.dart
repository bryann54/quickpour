part of 'user_data_bloc.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object?> get props => [];
}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final UserData userData;

  const UserDataLoaded(this.userData);

  @override
  List<Object?> get props => [userData];
}

class UserDataError extends UserDataState {
  final String message;

  const UserDataError(this.message);

  @override
  List<Object?> get props => [message];
}
