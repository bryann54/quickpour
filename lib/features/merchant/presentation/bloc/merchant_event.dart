part of 'merchant_bloc.dart';

abstract class MerchantEvent {}

class FetchMerchantEvent extends MerchantEvent {}

class FetchMoreMerchantsEvent extends MerchantEvent {}
