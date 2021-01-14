import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLogger.init();
  try {
    await Firebase.initializeApp();
  } on dynamic catch (error) {
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
    Bloc.observer = AppBlocObserver();

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
            create: (context) => AppUpdateCubit(
              dataRepository: dataRepository,
            ),
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
        child: BlocProvider<AppNavigatorCubit>(
          create: (context) => AppNavigatorCubit(
            BlocProvider.of<AppUpdateCubit>(context),
            BlocProvider.of<AuthenticationCubit>(context),
            BlocProvider.of<ProfileCubit>(context),
            BlocProvider.of<HomeCubit>(context),
          ),
          lazy: false,
          child: AppView(),
        ),
      ),
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();
NavigatorState get navigator => navigatorKey.currentState;

class AppView extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

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
      home: SplashScreen(),
    );
  }
}
