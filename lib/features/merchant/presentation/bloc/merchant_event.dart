part of 'merchant_bloc.dart';

abstract class MerchantEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMerchantEvent extends MerchantEvent {}

class FetchMoreMerchantsEvent extends MerchantEvent {}
