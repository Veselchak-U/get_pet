import 'package:cats/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double _kHorizontalPadding = 16.0;

class HomeScreen extends StatelessWidget {
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
  // HomeState _data;

  // @override
  // void initState() {
  //   _data = BlocProvider.of<HomeCubit>(context).state;
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        Widget result;
        if (state.status == HomeStatus.ready) {
          result = Scaffold(
            appBar: _AppBar(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Greeting(),
                  _SearchBar(),
                  _Header(index: 0, text: 'Pet Category'),
                  _CategoryGrid(),
                  _Header(index: 1, text: 'Newest Pet'),
                  _NewestCarousel(),
                  _Header(index: 2, text: 'Vets Near You'),
                ],
              ),
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
    HomeState data = BlocProvider.of<HomeCubit>(context).state;
    var theme = Theme.of(context);
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
                      onPressed: () {},
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
        SizedBox(width: _kHorizontalPadding),
      ],
    );
  }
}

class _UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeState data = BlocProvider.of<HomeCubit>(context).state;
    var theme = Theme.of(context);
    return FloatingActionButton(
      tooltip: 'Your profile',
      backgroundColor: theme.backgroundColor,
      mini: true,
      onPressed: () {},
      child: CircleAvatar(
        radius: 18.0,
        backgroundColor: theme.backgroundColor,
        backgroundImage:
            (data.userAvatarImage != null && data.userAvatarImage.isNotEmpty)
                ? NetworkImage(data.userAvatarImage)
                : AssetImage('assets/image/no_avatar.png'),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
      child: Column(
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
    _searchController.addListener(() {
      setState(() {
        // put search procedure here
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: _kHorizontalPadding, top: 16.0),
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
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(_kHorizontalPadding, 4.0, 8.0, 4.0),
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
    HomeState data = BlocProvider.of<HomeCubit>(context).state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
      child: GridView.count(
        crossAxisCount: 2,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 5 / 2,
        mainAxisSpacing: _kHorizontalPadding,
        crossAxisSpacing: _kHorizontalPadding,
        children: data.petCategories
            .map((PetCategory element) => _CategoryGridItem(item: element))
            .toList(),
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  const _CategoryGridItem({this.item});

  final PetCategory item;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () {},
      // onLongPress: () {},
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
                backgroundColor: item.background,
                child: CircleAvatar(
                  radius: 13.0,
                  backgroundColor: item.background,
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                        // color: _baseColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total of ${item.count}',
                    style: TextStyle(
                      // color: _baseColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewestCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
      child: Container(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: theme.primaryColorLight,
                border: Border.all(color: theme.primaryColorLight),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
