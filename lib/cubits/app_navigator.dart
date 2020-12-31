import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
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
    out('APP_NAVIGATOR_CUBIT create');
  }

  void _onChange() {
    // First, check app update
    if (_appUpdateStatus == AppUpdateStatus.unknown) {
      emit(state.copyWith(
        status: AppNavigatorStatus.check_update,
        statusText: 'Check updates...',
      ));
      return;
    }
    if (_appUpdateStatus == AppUpdateStatus.need_update) {
      emit(state.copyWith(
        status: AppNavigatorStatus.need_update,
        statusText: 'Update required.',
      ));
      return;
    }
    if (_appUpdateStatus == AppUpdateStatus.no_update ||
        _appUpdateStatus == AppUpdateStatus.error) {
      emit(state.copyWith(
        status: AppNavigatorStatus.no_update,
        statusText: 'Update not required.',
      ));
      // Second, check user auth
      _checkAuth();
    }
  }

  void _checkAuth() {
    if (_authenticationStatus == AuthenticationStatus.unknown) {
      emit(state.copyWith(
        status: AppNavigatorStatus.check_auth,
        statusText: 'Check authentication...',
      ));
      return;
    }
    if (_authenticationStatus == AuthenticationStatus.unauthenticated) {
      emit(state.copyWith(
        status: AppNavigatorStatus.unauthenticated,
        statusText: 'Authentication required.',
      ));
      _goToLoginScreen();
    }
    if (_authenticationStatus == AuthenticationStatus.authenticated) {
      emit(state.copyWith(
        status: AppNavigatorStatus.authenticated,
        statusText: 'Authentication not required.',
      ));
      _goToHomeScreen();
    }
  }

  void _goToLoginScreen() {
    navigator.pushAndRemoveUntil(
      LoginScreen().getRoute(),
      (Route route) => false,
    );
  }

  void _goToHomeScreen() async {
    emit(state.copyWith(
      status: AppNavigatorStatus.read_profile,
      statusText: 'Load user profile...',
    ));
    await _profileCubit.load();
    emit(state.copyWith(
      status: AppNavigatorStatus.read_home,
      statusText: 'Load home screen...',
    ));
    await _homeCubit.load();
    // ignore: unawaited_futures
    navigator.pushAndRemoveUntil(
      HomeScreen().getRoute(),
      (Route route) => false,
    );
  }

  @override
  Future<void> close() {
    out('APP_NAVIGATOR_CUBIT close');
    _appUpdateSubscription.cancel();
    _authenticationSubscription.cancel();
    return super.close();
  }
}

enum AppNavigatorStatus {
  init,
  check_update,
  no_update,
  need_update,
  check_auth,
  unauthenticated,
  authenticated,
  read_profile,
  read_home,
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
}