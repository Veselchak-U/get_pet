import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  final notificationCount = 2;
  final userAvatarImage =
      'https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _backgroundColor = Colors.white;
  final _iconColor = Colors.black54;
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
      appBar: _appBar(),
      body: Container(
        color: _backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              _searchBar(),
              _header(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.only(left: _horizontalPadding),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            bottomLeft: Radius.circular(32.0),
          ),
          color: Color.fromARGB(0xFF, 0xF5, 0xF5, 0xF5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 4.0),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: _iconColor),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel, color: _iconColor),
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

  Widget _header() {
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Lovely pet in anywhere',
            style: TextStyle(fontSize: 20),
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
          color: _iconColor,
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
                        color: _iconColor,
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
