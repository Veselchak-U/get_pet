import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/import.dart';

class AppBlocObserver extends BlocObserver {
  final logger = AppLogger.logger;

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    logger.e('ERROR in Cubit ${cubit.runtimeType}', error, stackTrace);
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    logger.i(
        'ON_CHANGE in Cubit ${cubit.runtimeType}: ${change.currentState} -> ${change.nextState}');
  }
}
