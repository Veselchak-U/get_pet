import 'package:firebase_core/firebase_core.dart';
import 'package:get_pet/cubits/authentication.dart';
import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add Firebase error handle
  try {
    await Firebase.initializeApp();
  } catch (error) {
    out(error);
  }
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthenticationRepository(),
        ),
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
            create: (context) => AuthenticationCubit(
              repo: RepositoryProvider.of<AuthenticationRepository>(context),
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              repo: RepositoryProvider.of<DatabaseRepository>(context),
            )..load(),
          ),
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(
              repo: RepositoryProvider.of<DatabaseRepository>(context),
            )..load(),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get navigator => navigatorKey.currentState;

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Pet',
      navigatorKey: navigatorKey,
      theme: theme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (_) => SplashScreen().getRoute(),
      // home: HomeScreen(),
      builder: (BuildContext context, Widget child) {
        return BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (BuildContext context, AuthenticationState state) {
            if (state.status == AuthenticationStatus.authenticated) {
              navigator.pushAndRemoveUntil(
                HomeScreen().getRoute(),
                (Route route) => false,
              );
            } else if (state.status == AuthenticationStatus.unauthenticated) {
              navigator.pushAndRemoveUntil(
                LoginScreen().getRoute(),
                (Route route) => false,
              );
            } else {}
          },
          child: child,
        );
      },
    );
  }
}
