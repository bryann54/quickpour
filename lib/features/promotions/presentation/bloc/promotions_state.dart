import 'package:equatable/equatable.dart';
import 'package:chupachap/features/promotions/data/models/promotion_model.dart';

abstract class PromotionsState extends Equatable {
  const PromotionsState();

  @override
  List<Object> get props => [];
}

class PromotionsInitial extends PromotionsState {}

class PromotionsLoading extends PromotionsState {}

class PromotionsLoaded extends PromotionsState {
  final List<PromotionModel> promotions;

  const PromotionsLoaded(this.promotions);

  @override
  List<Object> get props => [promotions];
}

class PromotionsError extends PromotionsState {
  final String message;

  const PromotionsError(this.message);

  @override
  List<Object> get props => [message];
}
