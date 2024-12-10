part of 'merchants_bloc.dart';

abstract class MerchantsState extends Equatable {
  const MerchantsState();

  @override
  List<Object> get props => [];
}

class MerchantsInitial extends MerchantsState {}
