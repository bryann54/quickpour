import 'package:chupachap/features/product/data/models/product_model.dart';

abstract class PromotionsState {}

class PromotionsInitial extends PromotionsState {}

class PromotionsLoading extends PromotionsState {}

class PromotionsLoaded extends PromotionsState {
  final List<ProductModel> products;
  PromotionsLoaded(this.products);
}

class PromotionsError extends PromotionsState {
  final String message;
  PromotionsError(this.message);
}
