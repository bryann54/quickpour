import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedBrand;
  String? selectedCategory;
  String? selectedStore;
  RangeValues _currentRangeValues = const RangeValues(0, 10000);
  bool _isLoading = true;
  List<String> brands = [];
  List<String> categories = [];
  List<String> stores = [];

  bool get _isFilterSelected {
    return selectedCategory != null ||
        selectedBrand != null ||
        selectedStore != null ||
        _currentRangeValues != const RangeValues(0, 10000);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _loadFilters() async {
    try {
      final categoryRepository = CategoryRepository();
      final merchantsRepository = MerchantsRepository();
      final brandRepository = BrandRepository();

      final categoriesList = await categoryRepository.getCategories();
      final merchantsList = await merchantsRepository.getMerchants();
      final brandsList = await brandRepository.getBrands();

      if (mounted) {
        setState(() {
          categories = categoriesList.map((category) => category.name).toList();
          stores = merchantsList.map((merchant) => merchant.name).toList();
          brands = brandsList.map((brand) => brand.name).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to load filters: ${e.toString()}');
      }
    }
  }

  void _applyFilters() {
    widget.onApplyFilters({
      'brand': selectedBrand,
      'category': selectedCategory,
      'store': selectedStore,
      'priceRange': _currentRangeValues,
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Filters',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator.adaptive(),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories
                    _buildSectionTitle('Category'),
                    const SizedBox(height: 8),
                    _buildCategoryChips(),
                    const SizedBox(height: 24),

                    // Brands
                    _buildSectionTitle('Brands'),
                    const SizedBox(height: 8),
                    _buildBrandChips(),
                    const SizedBox(height: 24),

                    // Stores
                    _buildSectionTitle('Stores'),
                    const SizedBox(height: 8),
                    _buildStoreChips(),
                    const SizedBox(height: 24),

                    // Price Range
                    _buildSectionTitle('Price Range'),
                    const SizedBox(height: 16),
                    _buildPriceRangeSlider(isDarkMode),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

          // Apply Button (conditionally rendered)
          if (_isFilterSelected)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      children: categories.map((category) {
        return ChoiceChip(
          label: Text(category),
          selected: selectedCategory == category,
          onSelected: (selected) {
            setState(() {
              selectedCategory = selected ? category : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildBrandChips() {
    return Wrap(
      spacing: 8,
      children: brands.map((brand) {
        return ChoiceChip(
          label: Text(brand),
          selected: selectedBrand == brand,
          onSelected: (selected) {
            setState(() {
              selectedBrand = selected ? brand : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildStoreChips() {
    return Wrap(
      spacing: 8,
      children: stores.map((store) {
        return ChoiceChip(
          label: Text(store),
          selected: selectedStore == store,
          onSelected: (selected) {
            setState(() {
              selectedStore = selected ? store : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSlider(bool isDarkMode) {
    return RangeSlider(
      values: _currentRangeValues,
      min: 0,
      max: 10000,
      divisions: 100,
      labels: RangeLabels(
        'Ksh ${_currentRangeValues.start.round()}',
        'Ksh ${_currentRangeValues.end.round()}',
      ),
      onChanged: (values) {
        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }
}
