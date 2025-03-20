part of 'brands_bloc.dart';

abstract class BrandsState extends Equatable {
  const BrandsState();

  @override
  List<Object?> get props => [];
}

class BrandsInitialState extends BrandsState {}

class BrandsLoadingState extends BrandsState {}

class BrandsLoadingMoreState extends BrandsState {
  final List<BrandModel> brands;
  final DateTime timestamp;

  const BrandsLoadingMoreState(this.brands, this.timestamp);

  @override
  List<Object?> get props => [brands, timestamp];
}

class BrandsLoadedState extends BrandsState {
  final List<BrandModel> brands;
  final DateTime timestamp;
  final bool hasMoreData;
  final String? errorMessage;

  const BrandsLoadedState(
    this.brands,
    this.timestamp, {
    this.hasMoreData = true,
    this.errorMessage,
  });

  BrandsLoadedState copyWith({
    List<BrandModel>? brands,
    DateTime? timestamp,
    bool? hasMoreData,
    String? errorMessage,
  }) {
    return BrandsLoadedState(
      brands ?? this.brands,
      timestamp ?? this.timestamp,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [brands, timestamp, hasMoreData, errorMessage];
}

class BrandsErrorState extends BrandsState {
  final String message;

  const BrandsErrorState(this.message);

  @override
  List<Object> get props => [message];
}
