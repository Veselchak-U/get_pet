import 'package:flutter/material.dart';
import 'package:get_pet/import.dart';

class SplashScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/splash',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );

  }
}
