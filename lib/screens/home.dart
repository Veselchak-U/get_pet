import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _backgroundColor = Colors.white;
  final _iconColor = Colors.black54;
  var _notificationCount = 7;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _appBar(),
          body: Container(
            color: _backgroundColor,
            child: Center(
              child: Text(
                'HomeScreen',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.97, -0.92),
          child: _userProfile(),
        ),
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.black26,//_backgroundColor, //Colors.black26,
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
        Stack(
          alignment: Alignment(0.75, -0.5),
          children: [
            Center(
              child: IconButton(
                tooltip: 'You have new notification',
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
                  '$_notificationCount',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        // _userProfile(),
        SizedBox(width: 70),
        // Material(
        //   elevation: 8.0,
        //   shape: CircleBorder(),
        //   // clipBehavior: Clip.antiAlias,
        //   child: CircleAvatar(
        //     radius: 28.0,
        //     backgroundColor: _backgroundColor,
        //     child: CircleAvatar(
        //       radius: 26.0,
        //       backgroundColor: Colors.orange,
        //       backgroundImage: NetworkImage('https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80'),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _userProfile() {
    return FloatingActionButton(
      elevation: 8.0,
      backgroundColor: _backgroundColor,
      onPressed: () {},
      child: CircleAvatar(
        radius: 26.0,
        backgroundColor: Colors.orange,
        backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80'),
      ),
    );
  }
}
