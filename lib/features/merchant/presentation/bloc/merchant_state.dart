part of 'merchant_bloc.dart';

abstract class MerchantState {}

class MerchantInitial extends MerchantState {}

class MerchantLoading extends MerchantState {}

class MerchantLoaded extends MerchantState {
  final List<Merchants> merchants;
  MerchantLoaded(this.merchants);
}

class MerchantError extends MerchantState {
  final String message;

  MerchantError(this.message);
}
