import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(App(
    databaseRepository: DatabaseRepository(),
  ));
}

class App extends StatelessWidget {
  const App({this.databaseRepository});

  final DatabaseRepository databaseRepository;

  @override
  Widget build(BuildContext context) {
    Widget result = AppView();

    result = BlocProvider(
      create: (BuildContext context) => HomeCubit(
        repo: RepositoryProvider.of<DatabaseRepository>(context),
      )..load(),
      child: result,
    );

    result = BlocProvider(
      create: (BuildContext context) => ProfileCubit(
        repo: RepositoryProvider.of<DatabaseRepository>(context),
      )..load(),
      child: result,
    );

    result = RepositoryProvider.value(
      value: databaseRepository,
      child: result,
    );
    return result;
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
      home: HomeScreen(),
    );
  }
}
