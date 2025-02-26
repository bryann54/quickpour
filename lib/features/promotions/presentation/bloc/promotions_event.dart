import 'package:equatable/equatable.dart';

abstract class PromotionsEvent extends Equatable {
  const PromotionsEvent();

  @override
  List<Object> get props => [];
}

class FetchActivePromotions extends PromotionsEvent {}
