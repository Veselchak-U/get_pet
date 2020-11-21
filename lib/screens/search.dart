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
          if (state.status == SearchStatus.initial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            SearchCubit cubit = BlocProvider.of<SearchCubit>(context);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _ChipFilter(
                    filter: state.categoryFilter,
                    items: state.categories,
                    onSelected: cubit.setCategoryFilter,
                  ),
                  _ChipFilter(
                    filter: state.conditionFilter,
                    items: state.conditions,
                    onSelected: cubit.setConditionFilter,
                  ),
                  // _CategoryFilter(),
                  // _ConditionFilter(),
                ],
              ),
            );
            // return Center(
            //   child: Text('Search screen: ${state.category}'),
            // );
          }
        },
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SearchCubit cubit = BlocProvider.of<SearchCubit>(context);
    SearchState state = cubit.state;
    if (state.categories != null && state.categories.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: 8.0),
        height: 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
              state.categories.length,
              (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FilterChip(
                      label: Text('${state.categories[index].name}'),
                      selected: (state.categoryFilter != null &&
                          state.categoryFilter?.id ==
                              state.categories[index].id),
                      onSelected: (bool value) {
                        cubit.setCategoryFilter(
                            value ? state.categories[index] : null);
                      },
                    ),
                  )),
        ),
      );
    } else {
      return SizedBox.shrink();
      // Center(
      //   child: SizedBox(
      //       width: 20,
      //       height: 20,
      //       child: CircularProgressIndicator(
      //         strokeWidth: 2.0,
      //       )),
      // );
    }
  }
}

class _ConditionFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchCubit cubit = BlocProvider.of<SearchCubit>(context);
    final ConditionModel filter = cubit.state.conditionFilter;
    final List<ConditionModel> items = cubit.state.conditions;
    if (items != null && items.isNotEmpty) {
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
                      label: Text('${items[index].name}'),
                      selected: filter?.id == items[index].id,
                      onSelected: (bool value) {
                        cubit.setConditionFilter(value ? items[index] : null);
                      },
                    ),
                  )),
        ),
      );
    } else {
      return SizedBox.shrink();
      // Center(
      //   child: SizedBox(
      //       width: 20,
      //       height: 20,
      //       child: CircularProgressIndicator(
      //         strokeWidth: 2.0,
      //       )),
      // );
    }
  }
}

class _ChipFilter<T> extends StatelessWidget {
  _ChipFilter({
    this.filter,
    this.items,
    this.onSelected,
  });

  final T filter;
  final List<T> items;
  final Function(T value) onSelected;

  @override
  Widget build(BuildContext context) {
    // final SearchCubit cubit = BlocProvider.of<SearchCubit>(context);
    // final ConditionModel filter = cubit.state.conditionFilter;
    // final List<ConditionModel> items = cubit.state.conditions;
    if (items != null && items.isNotEmpty) {
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
                      selected: filter == items[index],
                      onSelected: (bool value) {
                        onSelected(value ? items[index] : null);
                      },
                    ),
                  )),
        ),
      );
    } else {
      return SizedBox.shrink();
      // Center(
      //   child: SizedBox(
      //       width: 20,
      //       height: 20,
      //       child: CircularProgressIndicator(
      //         strokeWidth: 2.0,
      //       )),
      // );
    }
  }
}
