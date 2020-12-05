import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        centerTitle: true,
        elevation: 0.0,
        // automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () => navigator.pop(),
        //   ),
        //   Expanded(child: _LoginBar()),
        // ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            RepositoryProvider.of<AuthenticationRepository>(context)
                .signInWithGoogle();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.login),
              SizedBox(width: 16),
              Text('Log in with Google'),
            ],
          ),
        ),
      ),
    );
  }
}
