import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:get_pet/import.dart';
import 'package:package_info/package_info.dart';

part 'app_update.g.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit({this.dataRepository}) : super(const AppUpdateState()) {
    checkUpdate();
  }

  final DatabaseRepository dataRepository;

  Future<void> checkUpdate() async {
    if (state.status != AppUpdateStatus.unknown) {
      emit(state.copyWith(status: AppUpdateStatus.unknown));
    }

    int minVersion;
    try {
      final sysParam = await dataRepository.readSysParam('version_min');
      minVersion = int.parse(sysParam.value);
      // out('minVersion = $minVersion');
    } on dynamic catch (error, stackTrace) {
      emit(state.copyWith(status: AppUpdateStatus.error));
      onError(error, stackTrace);
    }

    int currVersion;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      // out(packageInfo.buildNumber);
      currVersion = int.parse(packageInfo.buildNumber);
    } on dynamic catch (error, stackTrace) {
      emit(state.copyWith(status: AppUpdateStatus.error));
      onError(error, stackTrace);
    }

    if (currVersion < minVersion) {
      emit(state.copyWith(status: AppUpdateStatus.need_update));
    } else {
      emit(state.copyWith(status: AppUpdateStatus.no_update));
    }
  }
}

enum AppUpdateStatus { need_update, no_update, error, unknown }

@CopyWith()
class AppUpdateState extends Equatable {
  const AppUpdateState({
    this.status = AppUpdateStatus.unknown,
  });

  final AppUpdateStatus status;

  @override
  List<Object> get props => [
        status,
      ];

  @override
  String toString() => status.toString();
}
