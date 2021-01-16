import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_pet/import.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final DateFormat dateTimeFormatter = DateFormat('dd.MM.yy HH:mm');
final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');

void out(Object value) {
  if (kDebugMode) debugPrint('$value');
  // print('$value');
}

void forcedUpdate(BuildContext context) {
  showYesNoDialog(
          context: context,
          titleText: 'New version released',
          contentText: 'Found a new version of the app, update now?')
      .then((result) {
    // Go to update page
    if (result) {
      launch(kUpdateUrl);
    }
    // Close app
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  });
}

Future<bool> showYesNoDialog({
  @required BuildContext context,
  String titleText = '',
  String contentText = '',
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(titleText),
        content: Text(contentText),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FlatButton(
            color: Theme.of(context).accentColor,
            shape: const StadiumBorder(),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

// ImageProvider<Object> getNetworkOrAssetImage({String url, String asset}) {
//   ImageProvider<Object> result;
//   if (url != null && url.isNotEmpty) {
//     result = NetworkImage(url);
//   } else {
//     result = AssetImage(asset);
//   }
//   return result;
// }
