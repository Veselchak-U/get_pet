import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/import.dart';

class AppBlocObserver extends BlocObserver {
  final logger = AppLogger.logger;

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    logger.e('ERROR in ${cubit.runtimeType}', error, stackTrace);
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onCreate(Cubit cubit) {
    logger.i('CREATE ${cubit.runtimeType}');
    super.onCreate(cubit);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    final type = cubit.runtimeType;
    final currentState = change.currentState;
    final nextState = change.nextState;
    logger.i('CHANGE in $type: $currentState -> $nextState');
    super.onChange(cubit, change);
  }

  @override
  void onClose(Cubit cubit) {
    logger.i('CLOSE ${cubit.runtimeType}');
    super.onClose(cubit);
  }
}
