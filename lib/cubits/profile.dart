import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:get_pet/import.dart';

part 'profile.g.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({this.dataRepository}) : super(const ProfileState());

  final DatabaseRepository dataRepository;

  Future<bool> load() async {
    var result = true;
    emit(state.copyWith(status: ProfileStatus.busy));
    try {
      final int notificationCount = await dataRepository.readNotificationCount();
      final String userName =
          'John Do Junior'; //await repo.readUserAvatarImage();
      final String userAvatarImage = await dataRepository.readUserAvatarImage();
      emit(state.copyWith(
        status: ProfileStatus.ready,
        notificationCount: notificationCount,
        userName: userName,
        userAvatarImage: userAvatarImage,
      ));
    } catch (error) {
      out(error);
      result = false;
      return Future.error(error);
    }
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
    this.notificationCount = 0,
    this.userName = '',
    this.userAvatarImage = '',
    this.sectionsVisibility = const [true, true, true],
  });

  final ProfileStatus status;
  final int notificationCount;
  final String userName;
  final String userAvatarImage;
  final List<bool> sectionsVisibility;

  @override
  List<Object> get props => [
        status,
        notificationCount,
        userName,
        userAvatarImage,
        sectionsVisibility,
      ];
}
