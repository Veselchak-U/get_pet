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
  final _searchBar = _SearchBar(); // statefull witget, create only once

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
          if (state.status == SearchStatus.initial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final SearchCubit cubit = BlocProvider.of<SearchCubit>(context);
            return Stack(
              children: [
                Column(
                  children: [
                    _searchBar,
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
                    _PetGrid(),
                  ],
                ),
                if (state.status == SearchStatus.busy)
                  Center(
                    child: CircularProgressIndicator(),
                  )
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
  SearchCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SearchCubit>(context);
    _searchController.addListener(() {
      setState(() {
        cubit.setQueryFilter(_searchController.text);
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
                    label: Text(items[index].toString()),
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

class _PetGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchCubit cubit = BlocProvider.of<SearchCubit>(context);
    if (cubit.state.foundPets.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'Nothing found',
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - (kHorizontalPadding * 3)) / 2;
    final cardHeight = 255.0;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            kHorizontalPadding, 0.0, kHorizontalPadding, kHorizontalPadding),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: cardWidth / cardHeight,
          mainAxisSpacing: kHorizontalPadding,
          crossAxisSpacing: kHorizontalPadding,
          children: cubit.state.foundPets
              .map((PetModel element) => _PetGridItem(item: element))
              .toList(),
        ),
      ),
    );
  }
}

class _PetGridItem extends StatelessWidget {
  const _PetGridItem({Key key, this.item}) : super(key: key);
  final PetModel item;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // navigator.push(DetailScreen(cubit: cubit, item: item).getRoute());
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.primaryColorLight,
            width: 2.0,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: item.id,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(item.photos),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 7,
                  right: -11,
                  child: FlatButton(
                    height: 30,
                    color: item.liked ? theme.selectedRowColor : Colors.white,
                    shape: CircleBorder(),
                    onPressed: () {
                      // cubit.onTapPetLike(petId: item.id);
                    },
                    child: Icon(
                      Icons.favorite,
                      color:
                          item.liked ? Colors.white : theme.textSelectionColor,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: item.condition.backgroundColor ??
                          theme.primaryColorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Text(
                        item.condition.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.condition.textColor ?? theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.breed.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                      ),
                      Text(
                        '${item.address} ( ${item.distance} km )',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
