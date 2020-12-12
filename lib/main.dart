import 'package:firebase_core/firebase_core.dart';
import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (error) {
    // TODO: add Firebase error handle
    out(error);
  }
  final authRepository = AuthenticationRepository();
  final dataRepository = DatabaseRepository(authRepository: authRepository);
  runApp(App(
    authRepository: authRepository,
    dataRepository: dataRepository,
  ));
}

class App extends StatelessWidget {
  App({
    @required this.authRepository,
    @required this.dataRepository,
  });

  final AuthenticationRepository authRepository;
  final DatabaseRepository dataRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authRepository,
        ),
        RepositoryProvider.value(
          value: dataRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
            create: (context) => AuthenticationCubit(
              authRepository: authRepository,
              dataRepository: dataRepository,
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              dataRepository: dataRepository,
            ),
          ),
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(
              dataRepository: dataRepository,
            ),
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
              BlocProvider.of<ProfileCubit>(context).load();
              BlocProvider.of<HomeCubit>(context).load();
              navigator.pushAndRemoveUntil(
                HomeScreen().getRoute(),
                (Route route) => false,
              );
            } else if (state.status == AuthenticationStatus.unauthenticated) {
              navigator.pushAndRemoveUntil(
                LoginScreen().getRoute(),
                (Route route) => false,
              );
            } else {} // AuthenticationStatus.unknown
          },
          child: child,
        );
      },
    );
  }
}
