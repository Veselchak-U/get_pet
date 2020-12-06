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
    // return BlocProvider(
    //   create: (BuildContext context) {
    //     final cubit = LoginCubit(
    //         repo: RepositoryProvider.of<DatabaseRepository>(context),
    //         category: category);
    //     cubit.init();
    //     return cubit;
    //   },
    //   lazy: false,
    //   child: _LoginBody(),
    // );
    return _LoginBody();
  }
}

class _LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              ElevatedButton(
                onPressed: () {
                  RepositoryProvider.of<AuthenticationRepository>(context)
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
    );
  }
}
