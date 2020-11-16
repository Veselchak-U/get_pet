import 'package:cats/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final _searchBar = _SearchBar(); // statefull witget, create only once

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/home',
      builder: (_) => this,
      fullscreenDialog: false,
      isInitialRoute: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      // buildWhen: (HomeState previous, HomeState current) =>
      //     current.status != previous.status,
      builder: (BuildContext context, HomeState state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
        Widget result;
        if (state.status == HomeStatus.ready ||
            state.status == HomeStatus.reload) {
          result = RefreshIndicator(
            onRefresh: () => cubit.load(isReload: true),
            child: Scaffold(
              appBar: _AppBar(),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Greeting(),
                    _searchBar,
                    _Header(index: 0, text: 'Pet Category'),
                    _CategoryGrid(),
                    _Header(index: 1, text: 'Newest Pet'),
                    _NewestPetsCarousel(),
                    _Header(index: 2, text: 'Vets Near You'),
                    _VetsCarousel(),
                  ],
                ),
              ),
              // floatingActionButton: FloatingActionButton(
              //   heroTag: 'HomeScreen_AddPet',
              //   tooltip: 'Add your pet',
              //   backgroundColor: theme.accentColor,
              //   onPressed: () {
              //     navigator.push(AddPetScreen().getRoute());
              //   },
              //   child: Icon(
              //     Icons.pets,
              //     size: 30,
              //     color: Colors.white,
              //   ),
              // ),
              // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            ),
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
    HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    HomeState data = cubit.state;
    // var theme = Theme.of(context);
    return AppBar(
      elevation: 0.0,
      leading: IconButton(
        tooltip: 'Something',
        icon: Icon(Icons.sort),
        onPressed: () {},
      ),
      actions: [
        (data.notificationCount != null && data.notificationCount > 0)
            ? Stack(
                alignment: Alignment(0.8, -0.5),
                children: [
                  Center(
                    child: IconButton(
                      tooltip:
                          'You have ${data.notificationCount} new notification(s)',
                      icon: Icon(Icons.notifications_none),
                      onPressed: () {
                        cubit.clearNotifications();
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 10.0,
                    backgroundColor: theme.backgroundColor,
                    child: CircleAvatar(
                      radius: 8.0,
                      backgroundColor: Colors.orange,
                      child: Text(
                        '${data.notificationCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        _UserProfile(),
        SizedBox(width: kHorizontalPadding),
      ],
    );
  }
}

class _UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    HomeState data = cubit.state;
    // var theme = Theme.of(context);
    return FloatingActionButton(
      tooltip: 'Your profile',
      heroTag: 'HomeScreen_UserProfile',
      backgroundColor: theme.backgroundColor,
      mini: true,
      onPressed: () {},
      child: CircleAvatar(
        radius: 18.0,
        backgroundColor: theme.backgroundColor,
        backgroundImage:
            (data.userAvatarImage != null && data.userAvatarImage.isNotEmpty)
                ? NetworkImage(data.userAvatarImage)
                : AssetImage('${kAssetPath}placeholder_avatar.png'),
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
              navigator.push(AddPetScreen().getRoute());
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(/* horizontal: kHorizontalPadding */),
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
      padding: EdgeInsets.only(left: kHorizontalPadding, top: 16.0),
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
            controller: _searchController,
            textInputAction: TextInputAction.search,
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

class _Header extends StatelessWidget {
  _Header({
    this.index,
    this.text,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    HomeState data = cubit.state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: GridView.count(
        crossAxisCount: 2,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 5 / 2,
        mainAxisSpacing: kHorizontalPadding,
        crossAxisSpacing: kHorizontalPadding,
        children: data.petCategories
            .map((CategoryModel element) => _CategoryGridItem(item: element))
            .toList(),
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  const _CategoryGridItem({this.item});

  final CategoryModel item;

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () {
        cubit.addNotification();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: theme.primaryColorLight,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          // color: _baseColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total of ${item.totalOf}',
                      style: TextStyle(
                        // color: _baseColor,
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
    HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    HomeState data = cubit.state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Container(
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
    HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    HomeState data = cubit.state;
    // ConditionModel itemCondition = data.conditions
    //     .firstWhere((ConditionModel e) => e.id == item.condition);
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
                  tag: '${item.id}',
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
                    color: item.liked ? Color(0xFFEE8363) : Colors.white,
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
                        item.condition.name ?? item.condition,
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
    HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    HomeState data = cubit.state;
    // var theme = Theme.of(context);
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
    HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
    var borderWidth = 2.0;
    // var boxWidth = MediaQuery.of(context).size.width -
    //     _kHorizontalPadding * 2 -
    //     borderWidth * 4;
    return Container(
      // width: boxWidth,
      margin: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: theme.primaryColorLight,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          cubit.callToPhoneNumber(phone: item.phone);
        },
        // onLongPress: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 100,
                child: Image(
                  image: NetworkImage(item.logoImage),
                  fit: BoxFit.scaleDown,
                ),
              ),
              SizedBox(width: 16.0),
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
                        shape: BoxShape.rectangle,
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
