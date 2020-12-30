import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/import.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    out('ERROR in Cubit ${cubit.runtimeType}: $error');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    out('ON_CHANGE in Cubit ${cubit.runtimeType}: ${change.currentState} -> ${change.nextState}');

    // First check app update
    if (cubit is AppUpdateCubit) {
      final AppUpdateState nextState = change.nextState as AppUpdateState;
      if (nextState.status == AppUpdateStatus.need_update) {
        out('ON_CHANGE in Cubit ${cubit.runtimeType}: need_update');
        return;
      }
      // if (nextState.status == AppUpdateStatus.no_update) {
      //   out('ON_CHANGE in Cubit ${cubit.runtimeType}: no_update');

      //   final authState = BlocProvider.of<AuthenticationCubit>(context).state;

      //   return BlocListener<AuthenticationCubit, AuthenticationState>(
      //     listener: (BuildContext context, AuthenticationState authState) {
      //       // if (needUpdateApp) {
      //       //   return;
      //       // }
      //       if (authState.status == AuthenticationStatus.authenticated) {
      //         BlocProvider.of<ProfileCubit>(context).load();
      //         BlocProvider.of<HomeCubit>(context).load();
      //         navigator.pushAndRemoveUntil(
      //           HomeScreen().getRoute(),
      //           (Route route) => false,
      //         );
      //       } else if (authState.status ==
      //           AuthenticationStatus.unauthenticated) {
      //         navigator.pushAndRemoveUntil(
      //           LoginScreen().getRoute(),
      //           (Route route) => false,
      //         );
      //       } else {} // AuthenticationStatus.unknown
      //     },
      //     // child: child,
      //   );
      // }
    }

    // Second check auth
  }
}
