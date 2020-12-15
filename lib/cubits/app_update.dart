import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'app_update.g.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit() : super(const AppUpdateState());

}

enum AppUpdateStatus { need_update, no_update, unknown }

@CopyWith()
class AppUpdateState extends Equatable {
  const AppUpdateState({
    this.status = AppUpdateStatus.no_update,
  });

  final AppUpdateStatus status;

  @override
  List<Object> get props => [
        status,
      ];
}
