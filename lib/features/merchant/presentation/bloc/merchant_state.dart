part of 'merchant_bloc.dart';

abstract class MerchantState {}

class MerchantInitial extends MerchantState {}

class MerchantLoading extends MerchantState {}

class MerchantLoaded extends MerchantState {
  final List<Merchants> merchants;
  final bool hasMoreData;

  MerchantLoaded({required this.merchants, required this.hasMoreData});

  MerchantLoaded copyWith({
    List<Merchants>? merchants,
    bool? hasMoreData,
  }) {
    return MerchantLoaded(
      merchants: merchants ?? this.merchants,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}

class MerchantError extends MerchantState {
  final String message;

  MerchantError(this.message);
}
