import 'package:cats/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({this.category});

  final CategoryModel category;

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/search?id=${category.id}',
      builder: (_) => this,
      fullscreenDialog: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final cubit = SearchCubit(
            repo: RepositoryProvider.of<DatabaseRepository>(context),
            category: category);
        cubit.init();
        return cubit;
      },
      lazy: false,
      child: _SearchBody(),
    );
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Your pet'),
        centerTitle: true,
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (BuildContext context, SearchState state) {
          if (state.status == SearchStatus.initial ||
              state.status == SearchStatus.busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            SearchCubit cubit = BlocProvider.of<SearchCubit>(context);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _ChipFilter<CategoryModel>(
                    filter: state.categoryFilter,
                    items: state.categories,
                    onSelected: cubit.setCategoryFilter,
                  ),
                  _ChipFilter<ConditionModel>(
                    filter: state.conditionFilter,
                    items: state.conditions,
                    onSelected: cubit.setConditionFilter,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _ChipFilter<T> extends StatelessWidget {
  _ChipFilter({
    @required this.filter,
    @required this.items,
    @required this.onSelected,
  });

  final T filter;
  final List<T> items;
  final Function(T value) onSelected;

  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
            items.length,
            (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FilterChip(
                    label: Text('${items[index].toString()}'),
                    selected: filter.toString() == items[index].toString(),
                    onSelected: (bool value) {
                      onSelected(value ? items[index] : null);
                    },
                  ),
                )),
      ),
    );
  }
}
