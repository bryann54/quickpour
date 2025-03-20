part of 'merchant_bloc.dart';

abstract class MerchantState extends Equatable {
  @override
  List<Object> get props => [];
}

class MerchantInitial extends MerchantState {}

class MerchantLoading extends MerchantState {}

class MerchantLoaded extends MerchantState {
  final List<Merchants> merchants;
  final bool hasMoreData;

  MerchantLoaded(this.merchants, {required this.hasMoreData});

  @override
  List<Object> get props => [merchants, hasMoreData];
}

class MerchantError extends MerchantState {
  final String message;

  MerchantError(this.message);

  @override
  List<Object> get props => [message];
}
