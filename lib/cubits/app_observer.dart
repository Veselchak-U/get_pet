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

    // if (cubit is AppUpdateCubit) {
    //   final AppUpdateState nextState = change.nextState as AppUpdateState;
    //   if (nextState.status == AppUpdateStatus.need_update) {
    //     out('ON_CHANGE in Cubit ${cubit.runtimeType}: need_update');
    //     return;
    //   }
    // }

  }
}
