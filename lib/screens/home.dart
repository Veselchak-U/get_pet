import 'package:cats/import.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final int notificationCount = 2;
  final String userAvatarImage =
      'https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80';
  final List<PetCategory> petCategories = [
    PetCategory(
      name: 'Hamster',
      count: 56,
      image: 'assets/image/hamster.png',
      background: Color(0xffF9EDD3),
    ),
    PetCategory(
      name: 'Cats',
      count: 210,
      image: 'assets/image/cat.png',
      background: Color(0xffD8F1FD),
    ),
    PetCategory(
      name: 'Bunnies',
      count: 90,
      image: 'assets/image/rabbit.png',
      background: Color(0xffE6F3E7),
    ),
    PetCategory(
      name: 'Dogs',
      count: 340,
      image: 'assets/image/dog.png',
      background: Color(0xffFAE0D8),
    ),
  ];
  final List<Pet> newestPets = [];

  final horizontalPadding = 16.0;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final _backgroundColor = Colors.white;
  // final _baseColor = Colors.black54;
  // final _searchBarBGColor = Color.fromARGB(0xFF, 0xF5, 0xF5, 0xF5);
  // final _categoryBorderColor = Color.fromARGB(0xFF, 0xF0, 0xF0, 0xF0);
  final _horizontalPadding = 16.0;
  final _searchController = TextEditingController();
  HomeScreen _data;

  @override
  void initState() {
    _data = widget;
    _searchController.addListener(() {
      setState(() {
        // put search procedure here
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(data: _data),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greeting(),
            _searchBar(),
            _header(index: 0, text: 'Pet Category'),
            _categoryGrid(),
            _header(index: 1, text: 'Newest Pet'),
            _newestCarousel(),
            _header(index: 2, text: 'Vets Near You'),
          ],
        ),
      ),
    );
  }

  Widget _newestCarousel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
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
                color: Theme.of(context).primaryColorLight,
                border: Border.all(color: Theme.of(context).primaryColorLight),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: GridView.count(
        crossAxisCount: 2,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 5 / 2,
        mainAxisSpacing: _horizontalPadding,
        crossAxisSpacing: _horizontalPadding,
        children: _data.petCategories
            .map((PetCategory element) => _categoryGridItem(item: element))
            .toList(),
      ),
    );
  }

  Widget _categoryGridItem({@required PetCategory item}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () {},
      // onLongPress: () {},
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Theme.of(context).primaryColorLight,
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

    // return Card(
    //   shape: RoundedRectangleBorder(
    //     side: BorderSide(width: 2.0, color: _categoryBorderColor),
    //     borderRadius: BorderRadius.circular(16.0),
    //   ),
    //   elevation: 0.0,
  }

  Widget _header({@required int index, @required String text}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, 4.0, 8.0, 4.0),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
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

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.only(left: _horizontalPadding, top: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            bottomLeft: Radius.circular(32.0),
          ),
          color: Theme.of(context).primaryColorLight,
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

  Widget _greeting() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          Text(
            'Find Your',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Lovely pet in anywhere',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({this.data});

  final HomeScreen data;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: Theme.of(context).backgroundColor,
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
        _UserProfile(data: data),
        SizedBox(width: data.horizontalPadding),
      ],
    );
  }
}

class _UserProfile extends StatelessWidget {
  const _UserProfile({this.data});

  final HomeScreen data;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Your profile',
      backgroundColor: Theme.of(context).backgroundColor,
      mini: true,
      onPressed: () {},
      child: CircleAvatar(
        radius: 18.0,
        backgroundColor: Theme.of(context).backgroundColor,
        backgroundImage:
            (data.userAvatarImage != null && data.userAvatarImage.isNotEmpty)
                ? NetworkImage(data.userAvatarImage)
                : AssetImage('assets/image/no_avatar.png'),
      ),
    );
  }
}
