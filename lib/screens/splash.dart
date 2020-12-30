import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    String _textState = '';

    out('SPLASH_SCREEN build()');

    return BlocBuilder<AppUpdateCubit, AppUpdateState>(
      builder: (context, state) {
        if (state.status == AppUpdateStatus.unknown) {
          _textState = 'Check updates...';
        } else if (state.status == AppUpdateStatus.need_update) {
          _textState = 'Update required.';
        } else if (state.status == AppUpdateStatus.no_update) {
          _textState = 'Update not required.';
        }
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
                  SizedBox(height: 50),
                  Text(
                    _textState,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
