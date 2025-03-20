import 'package:chupachap/features/categories/presentation/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/categories_bloc.dart';
import '../bloc/categories_state.dart';
import '../bloc/categories_event.dart';
import '../widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CategoriesBloc>().add(LoadCategories());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          context.read<CategoriesBloc>().state is CategoriesLoaded) {
        context.read<CategoriesBloc>().add(LoadMoreCategories());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => const LoadingHorizontalList(),
            );
          } else if (state is CategoriesLoaded) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: state.categories.length +
                        (state.hasMoreData
                            ? 1
                            : 0), // Add 1 for loading indicator
                    itemBuilder: (context, index) {
                      if (index < state.categories.length) {
                        final category = state.categories[index];
                        return CategoryCard(category: category);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                              alignment: Alignment.center,
                            child: CircularProgressIndicator.adaptive()),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          } else if (state is CategoriesError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No categories available.'));
        },
      ),
    );
  }
}
