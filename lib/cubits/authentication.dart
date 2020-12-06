import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:get_pet/import.dart';

part 'authentication.g.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({this.repo}) : super(const AuthenticationState()) {
    _userSubscription = repo.userChanges.listen(onUserChange);
  }

  final AuthenticationRepository repo;
  StreamSubscription<UserModel> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  void onUserChange(UserModel user) {
    AuthenticationState newState;
    if (user == UserModel.empty) {
      newState = state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        user: UserModel.empty,
      );
    } else {
      // out('user.displayName = ${user.displayName}');
      // out('user.photoURL = ${user.photoURL}');
      newState = state.copyWith(
        status: AuthenticationStatus.authenticated,
        user: user,
      );
    }
    emit(newState);
  }

  void requestLogout() {
    repo.logOut();
  }
}

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

@CopyWith()
class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.user = UserModel.empty,
  });

  final AuthenticationStatus status;
  final UserModel user;

  @override
  List<Object> get props => [
        status,
        user,
      ];
}
