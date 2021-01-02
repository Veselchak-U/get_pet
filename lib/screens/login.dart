import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_pet/import.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/login',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    out('LOGIN_SCREEN build()');
    return BlocConsumer<AppNavigatorCubit, AppNavigatorState>(
      listener: (context, state) {
        if (state.status == AppNavigatorStatus.need_update) {
          _showDialog(context, 'Found a new version of the app, update now?')
              .then((result) {
            if (result) {
              launch(kUpdateUrl);
            }
            // Close app
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          });
        }
      },
      builder: (context, state) {
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
                  Spacer(),
                  Text(
                    'Get Pet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(height: 32),
                  if (state.status != AppNavigatorStatus.unauthenticated)
                    CircularProgressIndicator(strokeWidth: 2)
                  else
                    SizedBox(height: 36),
                  SizedBox(height: 32),
                  Text(
                    state.statusText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 32),
                        ElevatedButton(
                          onPressed:
                              state.status == AppNavigatorStatus.check_update
                                  ? null
                                  : () {
                                      RepositoryProvider.of<
                                              AuthenticationRepository>(context)
                                          .signInWithGoogle();
                                    },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(FontAwesomeIcons.google),
                              SizedBox(width: 16),
                              Text('Log in with Google'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showDialog(BuildContext context, String questionText) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text(questionText),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
