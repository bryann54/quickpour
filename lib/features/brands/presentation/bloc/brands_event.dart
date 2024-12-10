part of 'brands_bloc.dart';

abstract class BrandsEvent extends Equatable {
  const BrandsEvent();

  @override
  List<Object> get props => [];
}

class FetchBrandsEvent extends BrandsEvent {}

class AddBrandEvent extends BrandsEvent {
  final BrandModel brand;

  const AddBrandEvent(this.brand);

  @override
  List<Object> get props => [brand];
}

class UpdateBrandEvent extends BrandsEvent {
  final BrandModel brand;

  const UpdateBrandEvent(this.brand);

  @override
  List<Object> get props => [brand];
}

class DeleteBrandEvent extends BrandsEvent {
  final String brandId;

  const DeleteBrandEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}
