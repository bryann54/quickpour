part of 'drink_request_bloc.dart';

abstract class DrinkRequestState extends Equatable {
  const DrinkRequestState();

  @override
  List<Object> get props => [];
}

class DrinkRequestInitial extends DrinkRequestState {}
