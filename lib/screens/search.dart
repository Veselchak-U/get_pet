import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({this.category});

  final CategoryModel category;

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/search?id=${category?.id}',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final searchCubit = SearchCubit(
            dataRepository: RepositoryProvider.of<DatabaseRepository>(context),
            category: category);
        searchCubit.init();
        return searchCubit;
      },
      lazy: false,
      child: _SearchBody(),
    );
  }
}

class _SearchBody extends StatelessWidget {
  final _searchBar = _SearchBar(); // statefull witget, create only once

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Your Pet'),
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
          if (state.status == SearchStatus.initial) {
            return Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          } else {
            final SearchCubit searchCubit =
                BlocProvider.of<SearchCubit>(context);
            return Column(
              children: [
                _searchBar,
                _ChipFilter<CategoryModel>(
                  selected: state.categoryFilter,
                  items: state.categories,
                  onSelected: searchCubit.setCategoryFilter,
                ),
                _ChipFilter<ConditionModel>(
                  selected: state.conditionFilter,
                  items: state.conditions,
                  onSelected: searchCubit.setConditionFilter,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      _PetGrid(),
                      if (state.status == SearchStatus.busy)
                        Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                    ],
                  ),
                ),
              ],
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
  SearchCubit searchCubit;

  @override
  void initState() {
    super.initState();
    searchCubit = BlocProvider.of<SearchCubit>(context);
    _searchController.addListener(() {
      setState(() {
        searchCubit.setQueryFilter(_searchController.text);
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            bottomLeft: Radius.circular(32.0),
          ),
          color: theme.primaryColorLight,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 4.0),
          child: TextField(
            controller: _searchController,
            // autofocus: true,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.done,
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
            // onChanged: (String value) {
            //   setState(() {
            //     cubit.setQueryFilter(value);
            //   });
            // },
          ),
        ),
      ),
    );
  }
}

class _ChipFilter<T> extends StatelessWidget {
  _ChipFilter({
    @required this.selected,
    @required this.items,
    @required this.onSelected,
  });

  final T selected;
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
                    label: Text(items[index].toString()),
                    elevation: 2.0,
                    selectedColor: Theme.of(context).accentColor,
                    selected: selected.toString() == items[index].toString(),
                    onSelected: (bool value) {
                      onSelected(value ? items[index] : null);
                    },
                  ),
                )),
      ),
    );
  }
}

class _PetGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchCubit searchCubit = BlocProvider.of<SearchCubit>(context);
    final List<PetModel> foundedPets = searchCubit.state.foundedPets;
    if (foundedPets.isEmpty) {
      return Center(
        child: Text(
          'Nothing found',
          style: TextStyle(
            fontSize: 18.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - (kHorizontalPadding * 3)) / 2;
    final cardHeight = 255.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          kHorizontalPadding, 0.0, kHorizontalPadding, kHorizontalPadding),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: cardWidth / cardHeight,
        mainAxisSpacing: kHorizontalPadding,
        crossAxisSpacing: kHorizontalPadding,
        children: List.generate(
            foundedPets.length,
            (index) => PetCard(
                  item: foundedPets[index],
                  onTap: () {
                    navigator.push(DetailScreen(
                      itemList: foundedPets,
                      item: foundedPets[index],
                      onTapLike: searchCubit.onTapLike,
                    ).getRoute());
                  },
                  onTapLike: () {
                    searchCubit.onTapLike(foundedPets[index]);
                  },
                )),
      ),
    );
  }
}
