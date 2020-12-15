import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (error) {
    out(error);
  }
  // Force enable Crashlytics collection while doing every day development.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

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
          BlocProvider<AppUpdateCubit>(
            create: (context) => AppUpdateCubit(),
          ),
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
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  bool needUpdateApp = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Pet',
      navigatorKey: navigatorKey,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: theme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (_) => SplashScreen().getRoute(),
      builder: (BuildContext context, Widget child) {
        return BlocListener<AppUpdateCubit, AppUpdateState>(
          listener: (BuildContext context, AppUpdateState appUpdateState) {
            if (appUpdateState.status == AppUpdateStatus.no_update) {
              needUpdateApp = false;
            }
          },
          child: BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (BuildContext context, AuthenticationState authState) {
              // if (needUpdateApp) {
              //   return;
              // }
              if (authState.status == AuthenticationStatus.authenticated) {
                BlocProvider.of<ProfileCubit>(context).load();
                BlocProvider.of<HomeCubit>(context).load();
                navigator.pushAndRemoveUntil(
                  HomeScreen().getRoute(),
                  (Route route) => false,
                );
              } else if (authState.status ==
                  AuthenticationStatus.unauthenticated) {
                navigator.pushAndRemoveUntil(
                  LoginScreen().getRoute(),
                  (Route route) => false,
                );
              } else {} // AuthenticationStatus.unknown
            },
            child: child,
          ),
        );
      },
    );
  }
}
