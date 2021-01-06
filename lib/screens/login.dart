import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_pet/import.dart';

class LoginScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/login',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppNavigatorCubit, AppNavigatorState>(
      listener: (context, state) {
        if (state.status == AppNavigatorStatus.need_update) {
          forcedUpdate(context);
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
}
