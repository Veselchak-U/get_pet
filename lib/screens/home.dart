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
  HomeScreen _data;

  @override
  void initState() {
    _data = widget;
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
            children: [
              _header(),
              Center(
                child: Text(
                  'HomeScreen',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HomeScreen',
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          'HomeScreen',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
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
      padding: EdgeInsets.only(right: 8.0),
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
}
