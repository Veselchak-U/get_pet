import 'package:cats/import.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({@required this.cubit, @required this.item});

  final HomeCubit cubit;
  final PetModel item;

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/detail?id=${item.id}',
      builder: (_) => this,
      fullscreenDialog: false,
    );
  }

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  HomeCubit cubit;
  String itemId;

  @override
  void initState() {
    super.initState();
    cubit = widget.cubit;
    itemId = widget.item.id;
  }

  @override
  Widget build(BuildContext context) {
    final PetModel item =
        cubit.state.newestPets.firstWhere((PetModel e) => e.id == itemId);
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        _swapItem(details: details, item: item);
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              // automaticallyImplyLeading: false,
              // leading: RaisedButton(
              //   shape: CircleBorder(),
              //   color: Colors.transparent.withOpacity(0.001),
              //   onPressed: () {
              //     navigator.pop(context);
              //   },
              //   child: Icon(Icons.arrow_back),
              // ),
              elevation: 0.0,
              expandedHeight: screenHeight - 20,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background: Hero(
                      tag: '${item.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item.photos),
                            fit: BoxFit.cover,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(
                        item: item,
                        onLiked: () {
                          setState(() {
                            cubit.onTapPetLike(petId: item.id);
                          });
                        },
                      ),
                      _Details(item: item),
                      _Story(item: item),
                      _Contact(item: item),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _swapItem({DragEndDetails details, PetModel item}) {
    var items = cubit.state.newestPets;
    var needUpdate = false;
    var newItemIndex;
    if (details.primaryVelocity > 0) {
      // swipe left
      newItemIndex = items.indexOf(item) - 1;
      if (newItemIndex >= 0) {
        needUpdate = true;
      }
    } else if (details.primaryVelocity < 0) {
      // swipe right
      newItemIndex = items.indexOf(item) + 1;
      if (newItemIndex < items.length) {
        needUpdate = true;
      }
    }
    if (needUpdate) {
      // print('newIndex = $newIndex');
      setState(() {
        itemId = items[newItemIndex].id;
      });
    }
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
          shape: BoxShape.rectangle,
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
              shape: BoxShape.rectangle,
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
  _Header({this.item, this.onLiked});

  final VoidCallback onLiked;
  final PetModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
                item.breed.name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0),
              ),
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
          color: item.liked ? Color(0xFFEE8363) : theme.primaryColorLight,
          shape: CircleBorder(),
          onPressed: onLiked,
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
  _Details({this.item});

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
          shape: BoxShape.rectangle,
          border: Border.all(
            color: theme.primaryColorLight,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: 4),
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
  _Story({this.item});

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
        Text(
          item.description,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              height: 2,
              letterSpacing: 0.5),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}

class _Contact extends StatelessWidget {
  _Contact({this.item});

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
              backgroundImage:
                  (item.member.photo != null && item.member.photo.isNotEmpty)
                      ? NetworkImage(item.member.photo)
                      : AssetImage('${kAssetPath}placeholder_avatar.png'),
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
          ElevatedButton(
            onPressed: () {
              // cubit.onTapPetLike(petId: item.id);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
              child: Text('Contact Me'),
            ),
          ),
        ],
      ),
    );
  }
}
