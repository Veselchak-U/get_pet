import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  final int notificationCount = 2;
  final String userAvatarImage =
      'https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80';
  final List<PetCategory> petCategory = [
    PetCategory(
        name: 'Hamster', count: 56, image: 'https://picsum.photos/id/433/100',),
    PetCategory(
        name: 'Cats', count: 210, image: 'https://picsum.photos/id/40/100'),
    PetCategory(
        name: 'Bunnies', count: 90, image: 'https://picsum.photos/id/582/100'),
    PetCategory(
        name: 'Dogs', count: 340, image: 'https://picsum.photos/id/1062/100'),
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class PetCategory {
  PetCategory(
      {@required this.name, @required this.image, @required this.count});

  final String name;
  final String image;
  final int count;
}

class _HomeScreenState extends State<HomeScreen> {
  final _backgroundColor = Colors.white;
  final _baseColor = Colors.black54;
  final _searchBarBGColor = Color.fromARGB(0xFF, 0xF5, 0xF5, 0xF5);
  final _categoryBorderColor = Color.fromARGB(0xFF, 0xF0, 0xF0, 0xF0);
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
      backgroundColor: _backgroundColor,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greeting(),
            _searchBar(),
            _header(index: 0, text: 'Pet Category'),
            _categoryGrid(),
            _header(index: 1, text: 'Newest Pet'),
            _header(index: 2, text: 'Vets Near You'),
          ],
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
        children: _data.petCategory
            .map((PetCategory element) => _categoryGridItem(item: element))
            .toList(),
      ),
    );
  }

  Widget _categoryGridItem({@required PetCategory item}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(
            color: _categoryBorderColor,
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
                backgroundColor: _backgroundColor,
                backgroundImage: NetworkImage(item.image),
              ),
              SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: TextStyle(
                          color: _baseColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text('Total of ${item.count}',
                      style: TextStyle(color: _baseColor, fontSize: 13)),
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
          Text(text,
              style: TextStyle(
                  color: _baseColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold)),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: _baseColor,
            ),
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
          color: _searchBarBGColor,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 4.0),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: _baseColor),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel, color: _baseColor),
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
          Container(
            width: double.infinity,
            child: SizedBox(height: 16.0),
          ),
          Text(
            'Find Your',
            style: TextStyle(
                color: _baseColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Lovely pet in anywhere',
            style: TextStyle(color: _baseColor, fontSize: 20),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: _backgroundColor,
      elevation: 0.0,
      leading: IconButton(
        tooltip: 'Something',
        icon: Icon(
          Icons.sort, //format_align_left,
          color: _baseColor,
        ),
        onPressed: () {},
      ),
      actions: [
        (_data.notificationCount != null && _data.notificationCount > 0)
            ? Stack(
                alignment: Alignment(0.8, -0.5),
                children: [
                  Center(
                    child: IconButton(
                      tooltip:
                          'You have ${_data.notificationCount} new notification(s)',
                      icon: Icon(
                        Icons.notifications_none,
                        color: _baseColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  CircleAvatar(
                    radius: 10.0,
                    backgroundColor: _backgroundColor,
                    child: CircleAvatar(
                      radius: 8.0,
                      backgroundColor: Colors.orange,
                      child: Text(
                        '${_data.notificationCount}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        _userProfile(),
      ],
    );
  }

  Widget _userProfile() {
    return Padding(
      padding: EdgeInsets.only(right: _horizontalPadding),
      child: FloatingActionButton(
        tooltip: 'Your profile',
        backgroundColor: _backgroundColor,
        mini: true,
        onPressed: () {},
        child: CircleAvatar(
          radius: 18.0,
          backgroundColor: _backgroundColor,
          backgroundImage: (_data.userAvatarImage != null &&
                  _data.userAvatarImage.isNotEmpty)
              ? NetworkImage(_data.userAvatarImage)
              : AssetImage('assets/image/no_avatar.png'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
