import 'package:flutter/material.dart';
import 'package:get_pet/import.dart';

class PetCard extends StatelessWidget {
  const PetCard({
    Key key,
    this.item,
    this.onTap,
    this.onTapLike,
  }) : super(key: key);

  final PetModel item;
  final VoidCallback onTap;
  final VoidCallback onTapLike;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - (kHorizontalPadding * 4)) / 2;
    return GestureDetector(
      onTap: onTap,
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
                    onPressed: onTapLike,
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
