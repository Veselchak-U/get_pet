import 'package:flutter/material.dart';
import 'package:get_pet/import.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/splash',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    out('SPLASH_SCREEN build()');

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      out(packageInfo.appName);
      out(packageInfo.packageName);
      out(packageInfo.version);
      out(packageInfo.buildNumber);
    });

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: [Colors.redAccent, Colors.yellowAccent],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Get Pet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none),
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(strokeWidth: 2),
            ],
          ),
        ),
      ],
    );
  }
}
