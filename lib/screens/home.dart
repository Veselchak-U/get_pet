import 'package:get_pet/cubits/authentication.dart';
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
            onRefresh: () => homeCubit.load(isReload: true),
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
              child: CircularProgressIndicator(),
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
          // navigator.pop();
          RepositoryProvider.of<AuthenticationRepository>(context).logOut();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Text('Log out'),
        ),
      ),
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationCubit authenticationCubit =
        BlocProvider.of<AuthenticationCubit>(context);
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
              authenticationCubit.state.user.displayName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
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
    final AuthenticationCubit authenticationCubit =
        BlocProvider.of<AuthenticationCubit>(context);
    return FloatingActionButton(
      tooltip: 'Your profile',
      heroTag: 'HomeScreen_UserProfile',
      backgroundColor: theme.backgroundColor,
      onPressed: null,
      child: CircleAvatar(
        radius: 26.0,
        backgroundColor: theme.backgroundColor,
        backgroundImage: getNetworkOrAssetImage(
          url: authenticationCubit.state.user.photoURL,
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
        onTap: () {
          navigator.push(SearchScreen().getRoute());
        },
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

class _ScreenSection extends StatelessWidget {
  _ScreenSection({this.index, this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
    final List<Widget> children = [];
    if (profileCubit.state.visibleSections[index] == true) {
      children.add(_Header(index: index, text: text));
      if (index == 0) {
        children.add(_CategoryGrid());
      }
      if (index == 1) {
        children.add(_NewestPetsCarousel());
      }
      if (index == 2) {
        children.add(_VetsCarousel());
      }
      if (index > 2) {
        children.add(SizedBox.shrink());
      }
    } else {
      children.add(SizedBox.shrink());
    }
    return Column(
      children: children,
    );
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
    final HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    final HomeState data = cubit.state;
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
      onTap: () {
        navigator.push(SearchScreen(
          category: item,
        ).getRoute());
      },
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
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total of ${item.totalOf}',
                      style: TextStyle(
                        fontSize: 13,
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

class _NewestPetsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    final HomeState data = cubit.state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: SizedBox(
        height: 255,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.newestPets.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(kHorizontalPadding / 2),
            child: _NewestCarouselItem(
              item: data.newestPets[index],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewestCarouselItem extends StatelessWidget {
  const _NewestCarouselItem({Key key, this.item}) : super(key: key);
  final PetModel item;
  @override
  Widget build(BuildContext context) {
    final HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - (kHorizontalPadding * 4)) / 2;
    return GestureDetector(
      onTap: () {
        navigator.push(DetailScreen(cubit: cubit, item: item).getRoute());
      },
      child: Container(
        width: cardWidth < 200 ? cardWidth : 200,
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
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),
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
                      cubit.onTapPetLike(petId: item.id);
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
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          // color: _baseColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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
