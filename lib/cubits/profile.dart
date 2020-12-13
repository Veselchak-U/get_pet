import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:get_pet/import.dart';

part 'profile.g.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({this.dataRepository}) : super(const ProfileState());

  final DatabaseRepository dataRepository;

  Future<bool> load() async {
    var result = false;
    emit(state.copyWith(status: ProfileStatus.busy));
    try {
      final int notificationCount =
          await dataRepository.readNotificationCount();
      final UserModel user = await dataRepository.readUserProfile();
      out(user.toJson());
      emit(state.copyWith(
        status: ProfileStatus.ready,
        user: user,
        notificationCount: notificationCount,
      ));
      result = true;
    } catch (error) {
      out(error);
      return Future.error(error);
    }
    out('PROFILE_CUBIT load()');
    return result;
  }

  void addNotification() {
    emit(state.copyWith(notificationCount: state.notificationCount + 1));
  }

  void clearNotifications() {
    emit(state.copyWith(notificationCount: 0));
  }

  void hideSection(int index) {
    final newSectionsVisibility = [...state.sectionsVisibility];
    newSectionsVisibility[index] = false;
    emit(state.copyWith(sectionsVisibility: newSectionsVisibility));
  }

  void restoreSectionsVisibility() {
    final newSectionsVisibility = const [true, true, true];
    emit(state.copyWith(sectionsVisibility: newSectionsVisibility));
  }
}

enum ProfileStatus { initial, busy, ready }

@CopyWith()
class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user = UserModel.empty,
    this.notificationCount = 0,
    this.sectionsVisibility = const [true, true, true],
  });

  final ProfileStatus status;
  final UserModel user;
  final int notificationCount;
  final List<bool> sectionsVisibility;

  @override
  List<Object> get props => [
        status,
        user,
        notificationCount,
        sectionsVisibility,
      ];
}
