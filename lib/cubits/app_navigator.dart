import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/import.dart';

part 'app_navigator.g.dart';

class AppNavigatorCubit extends Cubit<AppNavigatorState> {
  AppNavigatorCubit(
    this._appUpdateCubit,
    this._authenticationCubit,
    this._profileCubit,
    this._homeCubit,
  ) : super(const AppNavigatorState()) {
    _init();
  }

  final AppUpdateCubit _appUpdateCubit;
  final AuthenticationCubit _authenticationCubit;
  final ProfileCubit _profileCubit;
  final HomeCubit _homeCubit;

  StreamSubscription<AppUpdateState> _appUpdateSubscription;
  StreamSubscription<AuthenticationState> _authenticationSubscription;

  AppUpdateStatus _appUpdateStatus;
  AuthenticationStatus _authenticationStatus;
  bool _isNeedUpdateCheck = false;
  bool _isOnLoginScreen = false;

  void _init() {
    _appUpdateSubscription = _appUpdateCubit.listen((appUpdateCubitState) {
      if (_appUpdateStatus != appUpdateCubitState.status) {
        _appUpdateStatus = appUpdateCubitState.status;
        _onChange();
      }
    });
    _authenticationSubscription = _authenticationCubit.listen((authCubitState) {
      if (_authenticationStatus != authCubitState.status) {
        _authenticationStatus = authCubitState.status;
        _onChange();
      }
    });
  }

  void _onChange() {
    // First, check app update
    if (_appUpdateStatus == AppUpdateStatus.unknown) {
      emit(state.copyWith(
        status: AppNavigatorStatus.checkUpdate,
        statusText: 'Check updates...',
      ));
      return;
    }
    if (_appUpdateStatus == AppUpdateStatus.needUpdate) {
      emit(state.copyWith(
        status: AppNavigatorStatus.needUpdate,
        statusText: 'Update required',
      ));
      return;
    }
    if (_appUpdateStatus == AppUpdateStatus.noUpdate ||
        _appUpdateStatus == AppUpdateStatus.error) {
      emit(state.copyWith(
        status: AppNavigatorStatus.noUpdate,
        statusText: 'Update not required',
      ));
      // Second, check user auth
      _checkAuth();
    }
  }

  void _checkAuth() {
    if (_authenticationStatus == AuthenticationStatus.unknown) {
      emit(state.copyWith(
        status: AppNavigatorStatus.checkAuth,
        statusText: 'Check authentication...',
      ));
      return;
    }
    if (_authenticationStatus == AuthenticationStatus.unauthenticated) {
      emit(state.copyWith(
        status: AppNavigatorStatus.unauthenticated,
        statusText: 'Authentication required',
      ));
      _goToLoginScreen();
    }
    if (_authenticationStatus == AuthenticationStatus.authenticated) {
      emit(state.copyWith(
        status: AppNavigatorStatus.authenticated,
        statusText: 'Authentication not required',
      ));
      _goToHomeScreen();
    }
  }

  void _goToLoginScreen() {
    if (_isOnLoginScreen) {
      return;
    }
    if (_isNeedUpdateCheck) {
      _isNeedUpdateCheck = false;
      _appUpdateCubit.checkUpdate();
    }
    _isOnLoginScreen = true;
    navigator.pushAndRemoveUntil(
      LoginScreen().getRoute(),
      (route) => false,
    );
  }

  Future<void> _goToHomeScreen() async {
    _isOnLoginScreen = false;
    _isNeedUpdateCheck = true;

    emit(state.copyWith(
      status: AppNavigatorStatus.readProfile,
      statusText: 'Load user profile...',
    ));
    await _profileCubit.load();

    emit(state.copyWith(
      status: AppNavigatorStatus.readHome,
      statusText: 'Load home screen...',
    ));
    await _homeCubit.load();

    // ignore: unawaited_futures
    navigator.pushAndRemoveUntil(
      HomeScreen().getRoute(),
      (route) => false,
    );
  }

  @override
  Future<void> close() {
    _appUpdateSubscription.cancel();
    _authenticationSubscription.cancel();
    return super.close();
  }
}

enum AppNavigatorStatus {
  init,
  checkUpdate,
  noUpdate,
  needUpdate,
  checkAuth,
  unauthenticated,
  authenticated,
  readProfile,
  readHome,
}

@CopyWith()
class AppNavigatorState extends Equatable {
  const AppNavigatorState({
    this.status = AppNavigatorStatus.init,
    this.statusText = 'Initialization...',
  });

  final AppNavigatorStatus status;
  final String statusText;

  @override
  List<Object> get props => [
        status,
        statusText,
      ];

  @override
  String toString() => status.toString();
}
