import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_pet/import.dart';

class PetCard extends StatelessWidget {
  const PetCard({
    Key key,
    this.cardWidth,
    this.cardHeight,
    this.item,
    this.onTap,
    this.onTapLike,
  }) : super(key: key);

  final double cardWidth; // = 172;
  final double cardHeight; // = 278;
  final PetModel item;
  final VoidCallback onTap;
  final VoidCallback onTapLike;

  static const borderWidth = 2.0;
  static const borderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.primaryColorLight,
            width: borderWidth,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: item.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius - borderWidth),
                      topRight: Radius.circular(borderRadius - borderWidth),
                    ),
                    child: CachedNetworkImage(
                      width: cardWidth - borderWidth * 2,
                      height: cardHeight - 85, // TODO: calc exact height
                      fit: BoxFit.cover,
                      imageUrl: item.photos,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Placeholder(),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: FlatButton(
                    height: 30,
                    minWidth: 30,
                    padding: const EdgeInsets.all(8),
                    color: item.liked ? theme.selectedRowColor : Colors.white,
                    shape: const CircleBorder(),
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
              padding: const EdgeInsets.all(8.0),
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
                        style: TextStyle(
                          color: item.condition.textColor ?? theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.breed.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                      ),
                      Expanded(
                        child: Text(
                          '${item.address} ( ${item.distance} km )',
                          style: const TextStyle(fontSize: 11),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
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
