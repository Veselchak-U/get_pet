import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


final DateFormat dateTimeFormatter = DateFormat('dd.MM.yy HH:mm');
final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');

void out(dynamic value) {
  if (kDebugMode) debugPrint('$value');
}



ImageProvider<Object> getNetworkOrAssetImage({String url, String asset}) {
  ImageProvider<Object> result;
  if (url != null && url.isNotEmpty) {
    result = NetworkImage(url);
  } else {
    result = AssetImage(asset);
  }
  return result;
}
