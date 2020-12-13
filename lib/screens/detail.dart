import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';

typedef OnTapLike = void Function(String petId);

class DetailScreen extends StatefulWidget {
  DetailScreen({
    @required this.itemList,
    @required this.item,
    @required this.onTapLike,
  });

  final List<PetModel> itemList;
  final PetModel item;
  final OnTapLike onTapLike;

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/detail?id=${item.id}',
      builder: (_) => this,
    );
  }

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<PetModel> itemList;
  PetModel item;
  OnTapLike onTapLike;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    itemList = widget.itemList;
    item = widget.item;
    onTapLike = (_) {
      item = item.copyWith(liked: !item.liked);
      setState(() {
        widget.onTapLike(item.id);
      });
    };
    _pageController = PageController(initialPage: itemList.indexOf(item));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            leading: RaisedButton(
              shape: CircleBorder(),
              color: Colors.white.withOpacity(0.3),
              elevation: 0,
              onPressed: () {
                navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            ),
            elevation: 0.0,
            expandedHeight: screenHeight - 20,
            flexibleSpace: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      item = itemList[index];
                    });
                  },
                  children: List.generate(
                    itemList.length,
                    (index) => FlexibleSpaceBar(
                      background: Hero(
                        tag: itemList[index].id,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(itemList[index].photos),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _SliderCover(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: theme.backgroundColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(
                      item: item,
                      onTapLike: onTapLike,
                    ),
                    _Details(item),
                    _Story(item),
                    _Contact(item),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // ),
    );
  }
}

class _SliderCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: -1.0, // fix bug of rendering
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: Center(
          child: Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: theme.textSelectionColor,
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  _Header({this.item, this.onTapLike});

  final PetModel item;
  final OnTapLike onTapLike;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              item.breed.name,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 24),
                SizedBox(width: 8),
                Text(
                  '${item.address} ( ${item.distance} Km )',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        FlatButton(
          height: 48,
          color: item.liked ? theme.selectedRowColor : theme.primaryColorLight,
          shape: CircleBorder(),
          onPressed: () {
            onTapLike(item.id);
          },
          child: Icon(
            Icons.favorite,
            color: item.liked ? Colors.white : theme.textSelectionColor,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  _Details(this.item);

  final PetModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DetailsItem(name: 'Age', value: item.age),
          SizedBox(width: kHorizontalPadding),
          _DetailsItem(name: 'Color', value: item.coloring),
          SizedBox(width: kHorizontalPadding),
          _DetailsItem(name: 'Weight', value: '${item.weight} Kg'),
        ],
      ),
    );
  }
}

class _DetailsItem extends StatelessWidget {
  _DetailsItem({this.name, this.value});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.primaryColorLight,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _Story extends StatelessWidget {
  _Story(this.item);

  final PetModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pet Story',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 78,
          child: Text(
            item.description,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                height: 2,
                letterSpacing: 0.5),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}

class _Contact extends StatelessWidget {
  _Contact(this.item);

  final PetModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          FloatingActionButton(
            onPressed: null,
            heroTag: 'DetailScreen_Contact',
            backgroundColor: theme.backgroundColor,
            child: CircleAvatar(
              radius: 26.0,
              backgroundColor: theme.backgroundColor,
              backgroundImage: getNetworkOrAssetImage(
                url: item.member.photo,
                asset: '${kAssetPath}placeholder_avatar.png',
              ),
            ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posted by',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
              SizedBox(height: 4),
              Text(
                item.member.name,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.5),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Spacer(),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              //
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('Contact Me'),
            ),
          ),
        ],
      ),
    );
  }
}
