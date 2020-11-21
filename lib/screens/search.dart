import 'package:cats/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({this.category});

  final CategoryModel category;

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/search?id=${category?.id}',
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
        elevation: 0.0,
        // automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () => navigator.pop(),
        //   ),
        //   Expanded(child: _SearchBar()),
        // ],
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
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  _SearchBar(),
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

class _SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        // put search procedure here
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kHorizontalPadding, 0.0, 0.0, 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            bottomLeft: Radius.circular(32.0),
          ),
          color: theme.primaryColorLight,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 4.0),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: _searchController,
            textInputAction: TextInputAction.search,
            // style: TextStyle(fontSize: 18.0),
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
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
                    elevation: 2.0,
                    selectedColor: Theme.of(context).accentColor,
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
