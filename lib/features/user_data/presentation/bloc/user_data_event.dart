part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserData extends UserDataEvent {}

class UpdateUserData extends UserDataEvent {
  final UserData userData;

  const UpdateUserData(this.userData);

  @override
  List<Object?> get props => [userData];
}
