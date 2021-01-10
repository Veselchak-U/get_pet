import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/home',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, HomeState state) {
        final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
        Widget result;
        if (state.status == HomeStatus.ready ||
            state.status == HomeStatus.reload) {
          result = RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<ProfileCubit>(context).load();
              return homeCubit.load(isReload: true);
            },
            child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (BuildContext context, ProfileState state) {
              return Scaffold(
                key: _scaffoldKey,
                appBar: _AppBar(),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Greeting(),
                      _StaticSearchBar(),
                      _ScreenSection(index: 0, text: 'Pet Category'),
                      _ScreenSection(index: 1, text: 'Newest Pet'),
                      _ScreenSection(index: 2, text: 'Vets Near You'),
                    ],
                  ),
                ),
                drawer: Drawer(
                  child: _DrawerContent(),
                ),
              );
            }),
          );
        } else if (state.status == HomeStatus.busy) {
          result = Container(
            color: theme.backgroundColor,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (state.status == HomeStatus.initial) {
          result = Container(
            color: theme.backgroundColor,
            child: Center(
              child: Text('HomeStatus.initial'),
            ),
          );
        } else {
          result = Container(
            color: theme.backgroundColor,
            child: Center(
              child: Text('Unknown HomeStatus'),
            ),
          );
        }
        return result;
      },
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
    final ProfileState data = profileCubit.state;
    final theme = Theme.of(context);
    final List<Widget> actions = [];
    if (data.notificationCount > 0) {
      actions.add(Stack(
        alignment: Alignment(1.0, -0.5),
        children: [
          Center(
            child: IconButton(
              tooltip: 'You have ${data.notificationCount} new notification(s)',
              icon: Icon(Icons.notifications_none),
              onPressed: () {
                profileCubit.clearNotifications();
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                // constraints: BoxConstraints(minWidth: 17, minHeight: 17),
                decoration: BoxDecoration(
                  color: theme.selectedRowColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  child: Text(
                    '${data.notificationCount > 99 ? "99+" : data.notificationCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
    }
    actions.add(SizedBox(width: kHorizontalPadding));

    return AppBar(
      elevation: 0.0,
      leading: IconButton(
        tooltip: 'Menu',
        icon: Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
      actions: actions,
    );
  }
}

class _DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    return
        // Container(
        //   child: Column(
        //     children: [
        //       // Container(
        //       //   height: 150,
        //       //   child: Placeholder(),
        //       // ),
        //       DrawerHeader(
        //         child: Text('DrawerHeader'),
        //       ),
        LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // out('constraints.maxHeight = ${constraints.maxHeight}');
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _DrawerBody(),
                _DrawerButton(),
              ],
            ),
          ),
        );
      },
    );
    //     ],
    //   ),
    // );
  }
}

class _DrawerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
    final List<Widget> menuItems = [];
    menuItems.add(
      _UserProfileCard(),
    );
    menuItems.add(
      ListTile(
        leading: Icon(Icons.restore_page),
        title: Text('Restore sections visibility'),
        onTap: () {
          profileCubit.restoreSectionsVisibility();
          navigator.pop();
        },
      ),
    );
    // menuItems.addAll(
    //   List.generate(
    //     5,
    //     (index) => ExpansionTile(
    //       title: ListTile(
    //         leading: Icon(Icons.ac_unit),
    //         title: Text('MenuItem $index'),
    //       ),
    //       children: List.generate(
    //         3,
    //         (index2) => Padding(
    //           padding: const EdgeInsets.only(left: 24),
    //           child: ListTile(
    //             leading: Icon(Icons.menu_open),
    //             title: Text('MenuItem $index.$index2'),
    //             onTap: () {},
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Column(
      children: menuItems,
    );
  }
}

class _DrawerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          RepositoryProvider.of<AuthenticationRepository>(context).logOut();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('Log Out'),
        ),
      ),
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final AuthenticationCubit authenticationCubit =
    //     BlocProvider.of<AuthenticationCubit>(context);
    final ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
    return Container(
      height: 120,
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _UserProfileAvatar(),
            SizedBox(width: 16),
            Text(
              profileCubit.state.user.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final AuthenticationCubit authenticationCubit =
    //     BlocProvider.of<AuthenticationCubit>(context);
    final ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
    return FloatingActionButton(
      tooltip: 'Your profile',
      heroTag: 'HomeScreen_UserProfile',
      backgroundColor: theme.backgroundColor,
      onPressed: null,
      child: CircleAvatar(
        radius: 26.0,
        backgroundColor: theme.backgroundColor,
        backgroundImage: getNetworkOrAssetImage(
          url: profileCubit.state.user.photo,
          asset: '${kAssetPath}placeholder_avatar.png',
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text(
                'Find Your',
                style: TextStyle(
                    color: theme.primaryColorDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Lovely pet in anywhere',
                style: TextStyle(
                  color: theme.primaryColorDark,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final Future<PetModel> newPet =
                  navigator.push<PetModel>(AddPetScreen().getRoute());
              newPet.then((newPet) =>
                  BlocProvider.of<HomeCubit>(context).addNewPet(newPet));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  /* horizontal: kHorizontalPadding */),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pets),
                  SizedBox(width: 8),
                  Text('Or Add'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaticSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: kHorizontalPadding, top: 16.0),
      child: GestureDetector(
        onTap: () => _goToSearchScreen(context),
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
              enabled: false,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _goToSearchScreen(BuildContext context, [CategoryModel category]) {
  final Future<dynamic> result = navigator.push(SearchScreen(
    category: category,
  ).getRoute());
  // on back from SearchScreen update pet likes
  // TODO: remake to ChangeNotifier in DatabaseRepository
  result.then((value) {
    BlocProvider.of<HomeCubit>(context).load(isReload: true);
  });
}

class _ScreenSection extends StatelessWidget {
  _ScreenSection({this.index, this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
    final sectionsVisibility = profileCubit.state.sectionsVisibility;
    final List<Widget> sectionsWidgets = [
      _CategoryGrid(),
      _NewestPetsCarousel(),
      _VetsCarousel(),
    ];
    assert(sectionsVisibility.length == sectionsWidgets.length);
    assert(index < sectionsVisibility.length);

    if (sectionsVisibility[index] == true) {
      return Column(
        children: [
          _Header(index: index, text: text),
          sectionsWidgets[index],
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _Header extends StatelessWidget {
  _Header({
    this.index,
    this.text,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(kHorizontalPadding, 4.0, 8.0, 4.0),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
                color: theme.primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
          PopupMenuButton(
            icon: Icon(Icons.more_horiz),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: index,
                child: Text('Hide section'),
              )
            ],
            onSelected: (value) {
              profileCubit.addNotification();
              profileCubit.hideSection(index);
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
    final HomeState data = homeCubit.state;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemHeight = 60;
    final itemWidth = (screenWidth - 3 * kHorizontalPadding) / 2;
    final innerPadding = itemWidth > 160 ? 16.0 : 8.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: GridView.count(
        crossAxisCount: 2,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: itemWidth / itemHeight,
        mainAxisSpacing: kHorizontalPadding,
        crossAxisSpacing: kHorizontalPadding,
        children: data.petCategories
            .map((CategoryModel element) => _CategoryGridItem(
                  item: element,
                  innerPadding: innerPadding,
                ))
            .toList(),
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  const _CategoryGridItem({this.item, this.innerPadding});

  final CategoryModel item;
  final double innerPadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () => _goToSearchScreen(context, item),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.primaryColorLight,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: innerPadding,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundColor:
                    item.backgroundColor ?? theme.primaryColorLight,
                child: CircleAvatar(
                  radius: 13.0,
                  backgroundColor:
                      item.backgroundColor ?? theme.primaryColorLight,
                  child: item.assetImage != null
                      ? Image.asset(
                          '$kAssetPath${item.assetImage}',
                          fit: BoxFit.scaleDown,
                        )
                      : null,
                ),
              ),
              SizedBox(width: innerPadding),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      'Total of ${item.totalOf}',
                      style: TextStyle(fontSize: 13),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewestPetsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
    final List<PetModel> newestPets = homeCubit.state.newestPets;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: SizedBox(
        height: 255,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: newestPets.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(kHorizontalPadding / 2),
            child: PetCard(
              item: newestPets[index],
              onTap: () {
                navigator.push(DetailScreen(
                  itemList: newestPets,
                  item: newestPets[index],
                  onTapLike: homeCubit.onTapLike,
                ).getRoute());
              },
              onTapLike: () {
                homeCubit.onTapLike(newestPets[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _VetsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
    final HomeState data = homeCubit.state;
    return Container(
      height: 120,
      margin: EdgeInsets.only(bottom: kHorizontalPadding),
      child: PageView.builder(
        itemCount: data.nearestVets.length,
        // controller: PageController(viewportFraction: 1.0),
        itemBuilder: (context, index) =>
            _VetsCarouselItem(item: data.nearestVets[index]),
      ),
    );
  }
}

class _VetsCarouselItem extends StatelessWidget {
  const _VetsCarouselItem({Key key, this.item}) : super(key: key);
  final VetModel item;
  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
    final borderWidth = 2.0;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.primaryColorLight,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          homeCubit.callToPhoneNumber(phone: item.phone);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Image(
                  image: NetworkImage(item.logoImage),
                  fit: BoxFit.scaleDown,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                          // color: _baseColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 20,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          item.phone,
                          style: TextStyle(
                            // color: _baseColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: item.isOpenNow
                            ? Colors.green[100]
                            : Colors.blue[100],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: Text(
                          item.timetable,
                          style: TextStyle(
                            color: item.isOpenNow ? Colors.green : Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
