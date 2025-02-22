import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchProductsEvent extends ProductSearchEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FetchRecommendedProductsEvent extends ProductSearchEvent {
  final int limit;

  const FetchRecommendedProductsEvent({this.limit = 10});

  @override
  List<Object> get props => [limit];
}

class FilterProductsEvent extends ProductSearchEvent {
  final String? category;
  final String? store;
  final String? brand;
  final RangeValues? priceRange;

  const FilterProductsEvent({
    this.category,
    this.store,
    this.brand,
    this.priceRange,
  });

  @override
  List<Object> get props => [
        category ?? '', // Provide a default empty string for null
        store ?? '',
        brand ?? '', // Provide a default empty string for null
        priceRange ??
            const RangeValues(
                0, 10000), // Provide a default RangeValues for null
      ];
}
