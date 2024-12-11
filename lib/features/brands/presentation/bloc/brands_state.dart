part of 'brands_bloc.dart';

abstract class BrandsState extends Equatable {
  const BrandsState();

  @override
  List<Object> get props => [];
}

class BrandsInitialState extends BrandsState {}

class BrandsLoadingState extends BrandsState {}

class BrandsLoadedState extends BrandsState {
  final List<BrandModel> brands;

  const BrandsLoadedState(this.brands);

  @override
  List<Object> get props => [brands];
}

class BrandsErrorState extends BrandsState {
  final String errorMessage;

  const BrandsErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
