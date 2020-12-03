import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
