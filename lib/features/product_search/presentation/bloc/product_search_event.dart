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

class FilterProductsEvent extends ProductSearchEvent {
  final String? category;
  final String? store;
  final RangeValues? priceRange;

  const FilterProductsEvent({
    this.category,
    this.store,
    this.priceRange,
  });

  @override
  List<Object> get props => [
        category ?? '', // Provide a default empty string for null
        store ?? '', // Provide a default empty string for null
        priceRange ??
            RangeValues(0, 10000), // Provide a default RangeValues for null
      ];
}
